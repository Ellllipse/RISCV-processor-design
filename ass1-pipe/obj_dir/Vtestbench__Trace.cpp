// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vtestbench__Syms.h"


void Vtestbench::traceChgTop0(void* userp, VerilatedVcd* tracep) {
    Vtestbench__Syms* __restrict vlSymsp = static_cast<Vtestbench__Syms*>(userp);
    Vtestbench* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Variables
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    {
        vlTOPp->traceChgSub0(userp, tracep);
    }
}

void Vtestbench::traceChgSub0(void* userp, VerilatedVcd* tracep) {
    Vtestbench__Syms* __restrict vlSymsp = static_cast<Vtestbench__Syms*>(userp);
    Vtestbench* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    vluint32_t* const oldp = tracep->oldp(vlSymsp->__Vm_baseCode + 1);
    if (false && oldp) {}  // Prevent unused
    // Body
    {
        if (VL_UNLIKELY(vlTOPp->__Vm_traceActivity[1U])) {
            tracep->chgBit(oldp+0,(vlTOPp->testbench__DOT__dut__DOT__trapped));
            tracep->chgIData(oldp+1,(vlTOPp->testbench__DOT__x10),32);
            tracep->chgIData(oldp+2,(vlTOPp->testbench__DOT__imem_data),32);
            tracep->chgIData(oldp+3,(vlTOPp->testbench__DOT__dmem_rdata),32);
            tracep->chgIData(oldp+4,(vlTOPp->testbench__DOT__out),32);
            tracep->chgBit(oldp+5,(vlTOPp->testbench__DOT__out_valid));
            tracep->chgIData(oldp+6,(vlTOPp->testbench__DOT__i),32);
            tracep->chgIData(oldp+7,(vlTOPp->testbench__DOT__cycles),32);
            tracep->chgBit(oldp+8,(vlTOPp->testbench__DOT__dut__DOT__mem_rd_enable_q));
            tracep->chgCData(oldp+9,(vlTOPp->testbench__DOT__dut__DOT__mem_rd_reg_q),5);
            tracep->chgCData(oldp+10,(vlTOPp->testbench__DOT__dut__DOT__mem_rd_func_q),5);
            tracep->chgIData(oldp+11,(vlTOPp->testbench__DOT__dut__DOT__regfile[0]),32);
            tracep->chgIData(oldp+12,(vlTOPp->testbench__DOT__dut__DOT__regfile[1]),32);
            tracep->chgIData(oldp+13,(vlTOPp->testbench__DOT__dut__DOT__regfile[2]),32);
            tracep->chgIData(oldp+14,(vlTOPp->testbench__DOT__dut__DOT__regfile[3]),32);
            tracep->chgIData(oldp+15,(vlTOPp->testbench__DOT__dut__DOT__regfile[4]),32);
            tracep->chgIData(oldp+16,(vlTOPp->testbench__DOT__dut__DOT__regfile[5]),32);
            tracep->chgIData(oldp+17,(vlTOPp->testbench__DOT__dut__DOT__regfile[6]),32);
            tracep->chgIData(oldp+18,(vlTOPp->testbench__DOT__dut__DOT__regfile[7]),32);
            tracep->chgIData(oldp+19,(vlTOPp->testbench__DOT__dut__DOT__regfile[8]),32);
            tracep->chgIData(oldp+20,(vlTOPp->testbench__DOT__dut__DOT__regfile[9]),32);
            tracep->chgIData(oldp+21,(vlTOPp->testbench__DOT__dut__DOT__regfile[10]),32);
            tracep->chgIData(oldp+22,(vlTOPp->testbench__DOT__dut__DOT__regfile[11]),32);
            tracep->chgIData(oldp+23,(vlTOPp->testbench__DOT__dut__DOT__regfile[12]),32);
            tracep->chgIData(oldp+24,(vlTOPp->testbench__DOT__dut__DOT__regfile[13]),32);
            tracep->chgIData(oldp+25,(vlTOPp->testbench__DOT__dut__DOT__regfile[14]),32);
            tracep->chgIData(oldp+26,(vlTOPp->testbench__DOT__dut__DOT__regfile[15]),32);
            tracep->chgIData(oldp+27,(vlTOPp->testbench__DOT__dut__DOT__regfile[16]),32);
            tracep->chgIData(oldp+28,(vlTOPp->testbench__DOT__dut__DOT__regfile[17]),32);
            tracep->chgIData(oldp+29,(vlTOPp->testbench__DOT__dut__DOT__regfile[18]),32);
            tracep->chgIData(oldp+30,(vlTOPp->testbench__DOT__dut__DOT__regfile[19]),32);
            tracep->chgIData(oldp+31,(vlTOPp->testbench__DOT__dut__DOT__regfile[20]),32);
            tracep->chgIData(oldp+32,(vlTOPp->testbench__DOT__dut__DOT__regfile[21]),32);
            tracep->chgIData(oldp+33,(vlTOPp->testbench__DOT__dut__DOT__regfile[22]),32);
            tracep->chgIData(oldp+34,(vlTOPp->testbench__DOT__dut__DOT__regfile[23]),32);
            tracep->chgIData(oldp+35,(vlTOPp->testbench__DOT__dut__DOT__regfile[24]),32);
            tracep->chgIData(oldp+36,(vlTOPp->testbench__DOT__dut__DOT__regfile[25]),32);
            tracep->chgIData(oldp+37,(vlTOPp->testbench__DOT__dut__DOT__regfile[26]),32);
            tracep->chgIData(oldp+38,(vlTOPp->testbench__DOT__dut__DOT__regfile[27]),32);
            tracep->chgIData(oldp+39,(vlTOPp->testbench__DOT__dut__DOT__regfile[28]),32);
            tracep->chgIData(oldp+40,(vlTOPp->testbench__DOT__dut__DOT__regfile[29]),32);
            tracep->chgIData(oldp+41,(vlTOPp->testbench__DOT__dut__DOT__regfile[30]),32);
            tracep->chgIData(oldp+42,(vlTOPp->testbench__DOT__dut__DOT__regfile[31]),32);
            tracep->chgIData(oldp+43,(vlTOPp->testbench__DOT__dut__DOT__pc),32);
            tracep->chgIData(oldp+44,(vlTOPp->testbench__DOT__dut__DOT__imem_addr_q),32);
            tracep->chgBit(oldp+45,(vlTOPp->testbench__DOT__dut__DOT__isPCload));
            tracep->chgBit(oldp+46,(vlTOPp->testbench__DOT__dut__DOT__load_freeze));
            tracep->chgBit(oldp+47,(vlTOPp->testbench__DOT__dut__DOT__stall));
            tracep->chgBit(oldp+48,(vlTOPp->testbench__DOT__dut__DOT__Asrc));
            tracep->chgBit(oldp+49,(vlTOPp->testbench__DOT__dut__DOT__Bsrc));
            tracep->chgBit(oldp+50,(vlTOPp->testbench__DOT__dut__DOT__kill));
            tracep->chgIData(oldp+51,(vlTOPp->testbench__DOT__dut__DOT__insn_q),32);
            tracep->chgIData(oldp+52,(vlTOPp->testbench__DOT__dut__DOT__ppc),32);
            tracep->chgIData(oldp+53,(vlTOPp->testbench__DOT__dut__DOT__rs1_value_q),32);
            tracep->chgIData(oldp+54,(vlTOPp->testbench__DOT__dut__DOT__rs2_value_q),32);
            tracep->chgCData(oldp+55,((0x7fU & (vlTOPp->testbench__DOT__imem_data 
                                                >> 0x19U))),7);
            tracep->chgCData(oldp+56,((0x1fU & (vlTOPp->testbench__DOT__imem_data 
                                                >> 0x14U))),5);
            tracep->chgCData(oldp+57,((0x1fU & (vlTOPp->testbench__DOT__imem_data 
                                                >> 0xfU))),5);
            tracep->chgCData(oldp+58,((7U & (vlTOPp->testbench__DOT__imem_data 
                                             >> 0xcU))),3);
            tracep->chgCData(oldp+59,((0x1fU & (vlTOPp->testbench__DOT__imem_data 
                                                >> 7U))),5);
            tracep->chgCData(oldp+60,((0x7fU & vlTOPp->testbench__DOT__imem_data)),7);
            tracep->chgCData(oldp+61,((0x7fU & (vlTOPp->testbench__DOT__dut__DOT__insn_q 
                                                >> 0x19U))),7);
            tracep->chgCData(oldp+62,((0x1fU & (vlTOPp->testbench__DOT__dut__DOT__insn_q 
                                                >> 0x14U))),5);
            tracep->chgCData(oldp+63,((0x1fU & (vlTOPp->testbench__DOT__dut__DOT__insn_q 
                                                >> 0xfU))),5);
            tracep->chgCData(oldp+64,((7U & (vlTOPp->testbench__DOT__dut__DOT__insn_q 
                                             >> 0xcU))),3);
            tracep->chgCData(oldp+65,((0x1fU & (vlTOPp->testbench__DOT__dut__DOT__insn_q 
                                                >> 7U))),5);
            tracep->chgCData(oldp+66,((0x7fU & vlTOPp->testbench__DOT__dut__DOT__insn_q)),7);
            tracep->chgSData(oldp+67,((0xfffU & (vlTOPp->testbench__DOT__imem_data 
                                                 >> 0x14U))),12);
            tracep->chgSData(oldp+68,(vlTOPp->testbench__DOT__dut__DOT__imm_s),12);
            tracep->chgSData(oldp+69,(vlTOPp->testbench__DOT__dut__DOT__imm_b),13);
            tracep->chgIData(oldp+70,(vlTOPp->testbench__DOT__dut__DOT__imm_j),21);
            tracep->chgIData(oldp+71,(vlTOPp->testbench__DOT__dut__DOT__imm_i_sext_q),32);
            tracep->chgIData(oldp+72,(vlTOPp->testbench__DOT__dut__DOT__imm_s_sext_q),32);
            tracep->chgIData(oldp+73,(vlTOPp->testbench__DOT__dut__DOT__imm_b_sext_q),32);
            tracep->chgIData(oldp+74,(vlTOPp->testbench__DOT__dut__DOT__imm_j_sext_q),32);
            tracep->chgIData(oldp+75,(vlTOPp->testbench__DOT__dut__DOT__next_rd),32);
            tracep->chgBit(oldp+76,(vlTOPp->testbench__DOT__dut__DOT__trapped_q));
            tracep->chgBit(oldp+77,(vlTOPp->testbench__DOT__dut__DOT__reset_q));
            tracep->chgIData(oldp+78,(vlTOPp->testbench__DOT__dut__DOT__mem_rdata),32);
        }
        if (VL_UNLIKELY(vlTOPp->__Vm_traceActivity[2U])) {
            tracep->chgIData(oldp+79,(vlTOPp->testbench__DOT__imem_addr),32);
            tracep->chgBit(oldp+80,(vlTOPp->testbench__DOT__dmem_valid));
            tracep->chgIData(oldp+81,(vlTOPp->testbench__DOT__dmem_addr),32);
            tracep->chgCData(oldp+82,(vlTOPp->testbench__DOT__dmem_wstrb),4);
            tracep->chgIData(oldp+83,(vlTOPp->testbench__DOT__dmem_wdata),32);
            tracep->chgBit(oldp+84,((0x10000U > (0x3fffffffU 
                                                 & (vlTOPp->testbench__DOT__dmem_addr 
                                                    >> 2U)))));
            tracep->chgBit(oldp+85,((0x2000000U == vlTOPp->testbench__DOT__dmem_addr)));
            tracep->chgBit(oldp+86,(vlTOPp->testbench__DOT__dut__DOT__mem_wr_enable));
            tracep->chgIData(oldp+87,(vlTOPp->testbench__DOT__dut__DOT__mem_wr_addr),32);
            tracep->chgIData(oldp+88,(vlTOPp->testbench__DOT__dut__DOT__mem_wr_data),32);
            tracep->chgCData(oldp+89,(vlTOPp->testbench__DOT__dut__DOT__mem_wr_strb),4);
            tracep->chgBit(oldp+90,(vlTOPp->testbench__DOT__dut__DOT__mem_rd_enable));
            tracep->chgIData(oldp+91,(vlTOPp->testbench__DOT__dut__DOT__mem_rd_addr),32);
            tracep->chgCData(oldp+92,(vlTOPp->testbench__DOT__dut__DOT__mem_rd_reg),5);
            tracep->chgCData(oldp+93,(vlTOPp->testbench__DOT__dut__DOT__mem_rd_func),5);
            tracep->chgIData(oldp+94,(vlTOPp->testbench__DOT__dut__DOT__npc),32);
            tracep->chgBit(oldp+95,(vlTOPp->testbench__DOT__dut__DOT__next_wr));
            tracep->chgBit(oldp+96,(vlTOPp->testbench__DOT__dut__DOT__illinsn));
        }
        tracep->chgBit(oldp+97,(vlTOPp->clock));
        tracep->chgBit(oldp+98,(vlTOPp->reset));
    }
}

void Vtestbench::traceCleanup(void* userp, VerilatedVcd* /*unused*/) {
    Vtestbench__Syms* __restrict vlSymsp = static_cast<Vtestbench__Syms*>(userp);
    Vtestbench* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlSymsp->__Vm_activity = false;
        vlTOPp->__Vm_traceActivity[0U] = 0U;
        vlTOPp->__Vm_traceActivity[1U] = 0U;
        vlTOPp->__Vm_traceActivity[2U] = 0U;
    }
}
