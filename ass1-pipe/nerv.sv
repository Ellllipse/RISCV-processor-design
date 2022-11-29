// version exec
// forwarding with speculate (assuming branch not taken) + kill

module nerv #(
	parameter [31:0] RESET_ADDR = 32'h 0000_0000,
	parameter integer NUMREGS = 32
) (
	input clock,
	input reset,
	output trap,
    output logic [31:0] x10,

	// we have 2 external memories
	// one is instruction memory
	output [31:0] imem_addr,
	input  [31:0] imem_data,

	// the other is data memory
	output        dmem_valid,
	output [31:0] dmem_addr,
	output [ 3:0] dmem_wstrb,
	output [31:0] dmem_wdata,
	input  [31:0] dmem_rdata
);
	logic mem_wr_enable;
	logic [31:0] mem_wr_addr;
	logic [31:0] mem_wr_data;
	logic [3:0] mem_wr_strb;

	logic mem_rd_enable;
	logic [31:0] mem_rd_addr;
	logic [4:0] mem_rd_reg;
	logic [4:0] mem_rd_func;

	logic mem_rd_enable_q;
	logic [4:0] mem_rd_reg_q;
	logic [4:0] mem_rd_func_q;

	// delayed copies of mem_rd
	always @(posedge clock) begin
		mem_rd_enable_q <= mem_rd_enable;
		mem_rd_reg_q <= mem_rd_reg;
		mem_rd_func_q <= mem_rd_func;
		if (reset) begin
			mem_rd_enable_q <= 0;
		end
	end

	// memory signals
	assign dmem_valid = mem_wr_enable || mem_rd_enable;
	assign dmem_addr  = mem_wr_enable ? mem_wr_addr : mem_rd_enable ? mem_rd_addr : 32'h x;
	assign dmem_wstrb = mem_wr_enable ? mem_wr_strb : mem_rd_enable ? 4'h 0 : 4'h x;
	assign dmem_wdata = mem_wr_enable ? mem_wr_data : 32'h x;

	// registers, instruction reg, program counter, next pc
	logic [31:0] regfile [0:NUMREGS-1];
	wire [31:0] insn;
	logic [31:0] npc;
	logic [31:0] pc;

	logic [31:0] imem_addr_q; // this looks like a ppc

	always @(posedge clock) begin
		imem_addr_q <= imem_addr;
	end

	// instruction memory pointer
	assign imem_addr = (trap || mem_rd_enable) ? imem_addr_q : npc;
	assign insn = imem_data;

	// ===
	// load instruction detection
	logic isPCload; // check the current instruction is load
	logic load_freeze; // a flag that to check the npc had been freezed
	always_comb begin
		isPCload = (insn_opcode == 7'b0000011 && !load_freeze) ? 1:0;
	end
	always @(posedge clock) begin
		if (isPCload && !load_freeze)
			load_freeze = 1;
		else if (load_freeze) // this means it is in the additional instruction
			load_freeze = 0; // release the freeze
	end

	// ===

	// ===
	// stall detection 
	logic stall;
	always_comb begin
		case (insn_opcode)  
			7'b0100011: // S type
			// 7'b0110011, // R type
			// 7'b1100011: // B type
			begin
				stall = insn_rd_q == 0 ? 0 :((insn_rd_q == insn_rs1) || (insn_rd_q == insn_rs2));
				if (insn_opcode_q == 7'b1100011 || insn_opcode_q == 7'b0100011) stall = 0;
			end 
			7'b0000011, // L type
			// 7'b0010011, // I type
			7'b1100111: // JALR
			begin
				stall = insn_rd_q == 0 ? 0 :(insn_rd_q == insn_rs1);
				if (insn_opcode_q == 7'b1100011 || insn_opcode_q == 7'b0100011) stall = 0;
			end
			default: stall = 0;
		endcase
		
	end

	// check 1. when R type:
	// 						opcode = 7'b0110011
	// 						rs1 and rs2 = rd_q
	// check 2. when I type:
	// 						opcode = 7'b0010011
	// 						rs1 = rd_q
	// check 3. when B type:
	//						opcode = 7'b1100011
	// 						rs1 and rs2 = rd_q
	// check 4. when JALR:
	// 						opcode = 7'b1100111
	// 						rs1 = rd_q
	// check 5. when L type:
	// 						opcode = 7'b0000011
	// 						rs1 = rd_q
	// check 6. when S type:
	// 						opcode = 7'b0100011
	// 						rs1 and rs2 = rd_q
	// ===


	// ===
	// forward detection
	logic Asrc;
	logic Bsrc;
	always_comb begin
		Asrc = 0;
		Bsrc = 0;
		case (insn_opcode)  
			7'b0110011, // R type
			7'b1100011: // B type
			begin
				if ( (insn_rd_q != 0 && mem_rd_enable_q == 0 ) && !(insn_opcode_q == 7'b1100011 || insn_opcode_q == 7'b0100011) )begin
					// the case that R type instruction needed to be stalled
					Asrc = (insn_rd_q == insn_rs1) ? 1 : 0;
					Bsrc = (insn_rd_q == insn_rs2) ? 1 : 0;
				end
			end 
			7'b0010011: // I type
			begin
				if ( (insn_rd_q != 0 && mem_rd_enable_q == 0 ) && !(insn_opcode_q == 7'b1100011 || insn_opcode_q == 7'b0100011) )begin
					// the case that R type instruction needed to be stalled
					Asrc = (insn_rd_q == insn_rs1) ? 1 : 0;
					Bsrc = 0;
				end
			end
		endcase

	end
	// ===

	logic kill;

	logic [31:0] insn_q; // backup last instrcution
	logic [31:0] ppc;
	always @(posedge clock) begin
		if ((stall || kill) && !reset && !reset_q) begin
			insn_q <= 32'h 00000013;
		// end else if (stall && !reset && !reset_q) begin
		end else begin
			insn_q <= insn;
			ppc <= pc;
		end
	end

	// rs1 and rs2 are source for the instruction


	logic [31:0] rs1_value_q;
	logic [31:0] rs2_value_q;
	always @(posedge clock) begin
		if (Asrc) begin
			rs1_value_q <= next_rd;
			if (insn_opcode_q == OPCODE_LOAD)
				rs1_value_q <= mem_rdata;
		end else begin
			rs1_value_q <= !insn_rs1 ? 0 : regfile[insn_rs1];
		end 
		if (Bsrc) begin
			rs2_value_q <= next_rd;
			if (insn_opcode_q == OPCODE_LOAD)
				rs2_value_q <= mem_rdata;
		end else begin
			rs2_value_q <= !insn_rs2 ? 0 : regfile[insn_rs2];
		end 
		$display(pc);
	end

	// components of the instruction
	wire [6:0] insn_funct7;
	wire [4:0] insn_rs2;
	wire [4:0] insn_rs1;
	wire [2:0] insn_funct3;
	wire [4:0] insn_rd;
	wire [6:0] insn_opcode;

	// split R-type instruction - see section 2.2 of RiscV spec
	assign {insn_funct7, insn_rs2, insn_rs1, insn_funct3, insn_rd, insn_opcode} = insn;

	// components of the instruction
	wire [6:0] insn_funct7_q;
	wire [4:0] insn_rs2_q;
	wire [4:0] insn_rs1_q;
	wire [2:0] insn_funct3_q;
	wire [4:0] insn_rd_q;
	wire [6:0] insn_opcode_q;
	// get the previous control signal [insn_funct7_q, insn_funct3_q, insn_opcode_q], the rest are redumdent
	assign {insn_funct7_q, insn_rs2_q, insn_rs1_q, insn_funct3_q, insn_rd_q, insn_opcode_q} = insn_q;
	
	// setup for I, S, B & J type instructions
	// I - short immediates and loads
	wire [11:0] imm_i;
	assign imm_i = insn[31:20];

	// S - stores
	wire [11:0] imm_s;
	assign imm_s[11:5] = insn_funct7, imm_s[4:0] = insn_rd;

	// B - conditionals
	wire [12:0] imm_b;
	assign {imm_b[12], imm_b[10:5]} = insn_funct7, {imm_b[4:1], imm_b[11]} = insn_rd, imm_b[0] = 1'b0;

	// J - unconditional jumps
	wire [20:0] imm_j;
	assign {imm_j[20], imm_j[10:1], imm_j[11], imm_j[19:12], imm_j[0]} = {insn[31:12], 1'b0};

	logic [31:0] imm_i_sext_q; // backup last instrcution
	logic [31:0] imm_s_sext_q; // backup last instrcution
	logic [31:0] imm_b_sext_q; // backup last instrcution
	logic [31:0] imm_j_sext_q; // backup last instrcution
	
	always @(posedge clock) begin
		imm_i_sext_q <= $signed(imm_i);
		imm_s_sext_q <= $signed(imm_s);
		imm_b_sext_q <= $signed(imm_b);
		imm_j_sext_q <= $signed(imm_j);
	end

	// opcodes - see section 19 of RiscV spec
	localparam OPCODE_LOAD       = 7'b 00_000_11;
	localparam OPCODE_STORE      = 7'b 01_000_11;
	localparam OPCODE_MADD       = 7'b 10_000_11;
	localparam OPCODE_BRANCH     = 7'b 11_000_11;

	localparam OPCODE_LOAD_FP    = 7'b 00_001_11;
	localparam OPCODE_STORE_FP   = 7'b 01_001_11;
	localparam OPCODE_MSUB       = 7'b 10_001_11;
	localparam OPCODE_JALR       = 7'b 11_001_11;

	localparam OPCODE_CUSTOM_0   = 7'b 00_010_11;
	localparam OPCODE_CUSTOM_1   = 7'b 01_010_11;
	localparam OPCODE_NMSUB      = 7'b 10_010_11;
	localparam OPCODE_RESERVED_0 = 7'b 11_010_11;

	localparam OPCODE_MISC_MEM   = 7'b 00_011_11;
	localparam OPCODE_AMO        = 7'b 01_011_11;
	localparam OPCODE_NMADD      = 7'b 10_011_11;
	localparam OPCODE_JAL        = 7'b 11_011_11;

	localparam OPCODE_OP_IMM     = 7'b 00_100_11;
	localparam OPCODE_OP         = 7'b 01_100_11;
	localparam OPCODE_OP_FP      = 7'b 10_100_11;
	localparam OPCODE_SYSTEM     = 7'b 11_100_11;

	localparam OPCODE_AUIPC      = 7'b 00_101_11;
	localparam OPCODE_LUI        = 7'b 01_101_11;
	localparam OPCODE_RESERVED_1 = 7'b 10_101_11;
	localparam OPCODE_RESERVED_2 = 7'b 11_101_11;

	localparam OPCODE_OP_IMM_32  = 7'b 00_110_11;
	localparam OPCODE_OP_32      = 7'b 01_110_11;
	localparam OPCODE_CUSTOM_2   = 7'b 10_110_11;
	localparam OPCODE_CUSTOM_3   = 7'b 11_110_11;

	// next write, next destination (rd), illegal instruction registers
	logic next_wr;
	logic [31:0] next_rd;
	logic illinsn;

	logic trapped;
	logic trapped_q;
	assign trap = trapped;


	always_comb begin
		// advance pc
		npc = pc + 4;

		// defaults for read, write
		next_wr = 0;
		next_rd = 0;
		illinsn = 0;

		mem_wr_enable = 0;
		mem_wr_addr = 'hx;
		mem_wr_data = 'hx;
		mem_wr_strb = 'hx;

		mem_rd_enable = 0;
		mem_rd_addr = 'hx;
		mem_rd_reg = 'hx;
		mem_rd_func = 'hx;

		kill = 0;

		// act on opcodes
		case (insn_opcode_q)
			// Load Upper Immediate
			OPCODE_LUI: begin
				next_wr = 1;
				next_rd = insn_q[31:12] << 12;
			end
			// Add Upper Immediate to Program Counter
			OPCODE_AUIPC: begin
				next_wr = 1;
				next_rd = (insn_q[31:12] << 12) + pc;
			end
			// Jump And Link (unconditional jump)
			OPCODE_JAL: begin
				kill = 1;
				next_wr = 1;
				next_rd = ppc+4;
				npc = ppc + imm_j_sext_q;
				if (npc & 32'b 11) begin
					illinsn = 1;
					npc = npc & ~32'b 11;
				end
			end
			// Jump And Link Register (indirect jump)
			OPCODE_JALR: begin
				case (insn_funct3_q)
					3'b 000 /* JALR */: begin
						kill = 1;
						next_wr = 1;
						next_rd = ppc+4;
						npc = (rs1_value_q + imm_i_sext_q) & ~32'b 1;
					end
					default: illinsn = 1;
				endcase
				if (npc & 32'b 11) begin
					illinsn = 1;
					npc = npc & ~32'b 11;
				end
			end
			// branch instructions: Branch If Equal, Branch Not Equal, Branch Less Than, Branch Greater Than, Branch Less Than Unsigned, Branch Greater Than Unsigned
			OPCODE_BRANCH: begin
				case (insn_funct3_q)
					3'b 000 /* BEQ  */: begin if (rs1_value_q == rs2_value_q) begin kill = 1; npc = ppc + imm_b_sext_q; end end
					3'b 001 /* BNE  */: begin if (rs1_value_q != rs2_value_q) begin kill = 1; npc = ppc + imm_b_sext_q; end end
					3'b 100 /* BLT  */: begin if ($signed(rs1_value_q) < $signed(rs2_value_q)) begin kill = 1; npc = ppc + imm_b_sext_q; end end
					3'b 101 /* BGE  */: begin if ($signed(rs1_value_q) >= $signed(rs2_value_q)) begin kill = 1; npc = ppc + imm_b_sext_q; end end
					3'b 110 /* BLTU */: begin if (rs1_value_q < rs2_value_q) begin kill = 1; npc = ppc + imm_b_sext_q; end end
					3'b 111 /* BGEU */: begin if (rs1_value_q >= rs2_value_q) begin kill = 1; npc = ppc + imm_b_sext_q; end end
					default: illinsn = 1;
				endcase
				if (npc & 32'b 11) begin
					illinsn = 1;
					npc = npc & ~32'b 11;
				end
			end
			// load from memory into rd: Load Byte, Load Halfword, Load Word, Load Byte Unsigned, Load Halfword Unsigned
			OPCODE_LOAD: begin
				mem_rd_addr = rs1_value_q + imm_i_sext_q;
				casez ({insn_funct3_q, mem_rd_addr[1:0]})
					5'b 000_zz /* LB  */,
					5'b 001_z0 /* LH  */,
					5'b 010_00 /* LW  */,
					5'b 100_zz /* LBU */,
					5'b 101_z0 /* LHU */: begin
						mem_rd_enable = 1;
						mem_rd_reg = insn_rd_q;
						mem_rd_func = {mem_rd_addr[1:0], insn_funct3_q};
						mem_rd_addr = {mem_rd_addr[31:2], 2'b 00};
					end
					default: illinsn = 1;
				endcase
			end
			// store to memory instructions: Store Byte, Store Halfword, Store Word
			OPCODE_STORE: begin
				mem_wr_addr = rs1_value_q + imm_s_sext_q;
				casez ({insn_funct3_q, mem_wr_addr[1:0]})
					5'b 000_zz /* SB */,
					5'b 001_z0 /* SH */,
					5'b 010_00 /* SW */: begin
						mem_wr_enable = 1;
						mem_wr_data = rs2_value_q;
						mem_wr_strb = 4'b 1111;
						case (insn_funct3_q)
							3'b 000 /* SB  */: begin mem_wr_strb = 4'b 0001; end
							3'b 001 /* SH  */: begin mem_wr_strb = 4'b 0011; end
							3'b 010 /* SW  */: begin mem_wr_strb = 4'b 1111; end
						endcase
						mem_wr_data = mem_wr_data << (8*mem_wr_addr[1:0]);
						mem_wr_strb = mem_wr_strb << mem_wr_addr[1:0];
						mem_wr_addr = {mem_wr_addr[31:2], 2'b 00};
					end
					default: illinsn = 1;
				endcase
			end
			// immediate ALU instructions: Add Immediate, Set Less Than Immediate, Set Less Than Immediate Unsigned, XOR Immediate,
			// OR Immediate, And Immediate, Shift Left Logical Immediate, Shift Right Logical Immediate, Shift Right Arithmetic Immediate
			OPCODE_OP_IMM: begin
				if ((stall && !reset && !reset_q))
					npc = npc - 4; // npc = current PC (freeze the pc)
				casez ({insn_funct7_q, insn_funct3_q})
					10'b zzzzzzz_000 /* ADDI  */: begin next_wr = 1; next_rd = rs1_value_q + imm_i_sext_q; end
					10'b zzzzzzz_010 /* SLTI  */: begin next_wr = 1; next_rd = $signed(rs1_value_q) < $signed(imm_i_sext_q); end
					10'b zzzzzzz_011 /* SLTIU */: begin next_wr = 1; next_rd = rs1_value_q < imm_i_sext_q; end
					10'b zzzzzzz_100 /* XORI  */: begin next_wr = 1; next_rd = rs1_value_q ^ imm_i_sext_q; end
					10'b zzzzzzz_110 /* ORI   */: begin next_wr = 1; next_rd = rs1_value_q | imm_i_sext_q; end
					10'b zzzzzzz_111 /* ANDI  */: begin next_wr = 1; next_rd = rs1_value_q & imm_i_sext_q; end
					10'b 0000000_001 /* SLLI  */: begin next_wr = 1; next_rd = rs1_value_q << insn_q[24:20]; end
					10'b 0000000_101 /* SRLI  */: begin next_wr = 1; next_rd = rs1_value_q >> insn_q[24:20]; end
					10'b 0100000_101 /* SRAI  */: begin next_wr = 1; next_rd = $signed(rs1_value_q) >>> insn_q[24:20]; end
					default: illinsn = 1;
				endcase
			end
			OPCODE_OP: begin
				if ((stall && !reset && !reset_q))
					npc = npc - 4; // npc = current PC (freeze the pc)
			// ALU instructions: Add, Subtract, Shift Left Logical, Set Left Than, Set Less Than Unsigned, XOR, Shift Right Logical,
			// Shift Right Arithmetic, OR, AND
				case ({insn_funct7_q, insn_funct3_q})
					10'b 0000000_000 /* ADD  */: begin next_wr = 1; next_rd = rs1_value_q + rs2_value_q; end
					10'b 0100000_000 /* SUB  */: begin next_wr = 1; next_rd = rs1_value_q - rs2_value_q; end
					10'b 0000000_001 /* SLL  */: begin next_wr = 1; next_rd = rs1_value_q << rs2_value_q[4:0]; end
					10'b 0000000_010 /* SLT  */: begin next_wr = 1; next_rd = $signed(rs1_value_q) < $signed(rs2_value_q); end
					10'b 0000000_011 /* SLTU */: begin next_wr = 1; next_rd = rs1_value_q < rs2_value_q; end
					10'b 0000000_100 /* XOR  */: begin next_wr = 1; next_rd = rs1_value_q ^ rs2_value_q; end
					10'b 0000000_101 /* SRL  */: begin next_wr = 1; next_rd = rs1_value_q >> rs2_value_q[4:0]; end
					10'b 0100000_101 /* SRA  */: begin next_wr = 1; next_rd = $signed(rs1_value_q) >>> rs2_value_q[4:0]; end
					10'b 0000000_110 /* OR   */: begin next_wr = 1; next_rd = rs1_value_q | rs2_value_q; end
					10'b 0000000_111 /* AND  */: begin next_wr = 1; next_rd = rs1_value_q & rs2_value_q; end
					default: illinsn = 1;
				endcase
			end
			default: illinsn = 1;
		endcase

		if (!isPCload && load_freeze) begin
			npc = pc ;
			
		end 

		// if last cycle was a memory read, then this cycle is the 2nd part of it and imem_data will not be a valid instruction
		if (mem_rd_enable_q) begin
			next_wr = 0;
			illinsn = 0;
			mem_rd_enable = 0;
			mem_wr_enable = 0;
		end

		// reset
		if (reset || reset_q) begin
			npc = RESET_ADDR;
			next_wr = 0;
			illinsn = 0;
			mem_rd_enable = 0;
			mem_wr_enable = 0;
		end
	end

	logic reset_q;
	logic [31:0] mem_rdata;

	// mem read functions: Lower and Upper Bytes, signed and unsigned
	always_comb begin
		mem_rdata = dmem_rdata >> (8*mem_rd_func_q[4:3]);
		case (mem_rd_func_q[2:0])
			3'b 000 /* LB  */: begin mem_rdata = $signed(mem_rdata[7:0]); end
			3'b 001 /* LH  */: begin mem_rdata = $signed(mem_rdata[15:0]); end
			3'b 100 /* LBU */: begin mem_rdata = mem_rdata[7:0]; end
			3'b 101 /* LHU */: begin mem_rdata = mem_rdata[15:0]; end
		endcase
	end

	// every cycle
	always @(posedge clock) begin
		reset_q <= reset;
		trapped_q <= trapped;

		// increment pc if possible
		if (!trapped && !reset && !reset_q) begin
			if (illinsn)
				trapped <= 1;
			if (!stall ) begin
				pc <= npc;
			end 

			// update registers from memory or rd (destination)
			if (mem_rd_enable_q || next_wr)
				regfile[mem_rd_enable_q ? mem_rd_reg_q : insn_rd_q] <= mem_rd_enable_q ? mem_rdata : next_rd;

			x10 <= regfile[10];
		end

		// reset
		if (reset || reset_q) begin
			pc <= RESET_ADDR - (reset ? 4 : 0);
			trapped <= 0;
		end
	end

endmodule