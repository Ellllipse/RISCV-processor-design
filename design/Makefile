TOOLCHAIN_PREFIX?=riscv32-unknown-elf-
CC=$(TOOLCHAIN_PREFIX)gcc
AS=$(TOOLCHAIN_PREFIX)as
CFLAGS=	-O1 -march=rv32i -mabi=ilp32 
SOURCES = nerv.sv testbench.sv testbench.py
RDOCKER = docker run --platform linux/amd64 -it -e DISPLAY=host.docker.internal:0 -v `pwd`:/config phwl/elec3608-riscv:latest

OBJ=	program
all:	$(OBJ) test2.out Best_cache Optimised_cache

# produce an executable with the printf for execution in spike
$(OBJ):	$(OBJ).o
	$(CC) $(CFLAGS) $(OBJ).o -o $(OBJ)

$(OBJ).s:	$(OBJ).c
	$(CC) -S $(CFLAGS) $(OBJ).c

$(OBJ).o:	$(OBJ).s
	$(AS) --traditional-format -march=rv32i -mabi=ilp32 -o $(OBJ).o $(OBJ).s

# execute $(OBJ) using spike simulator
test:
	-spike --isa=rv32i --ic=2:4:8 --dc=2:4:8  /opt/riscv/riscv32-unknown-elf/bin/pk $(OBJ)

Best_cache:
	-spike --isa=rv32i --ic=1:64:1024 --dc=1:128:1024 /opt/riscv/riscv32-unknown-elf/bin/pk $(OBJ)

Optimised_cache:
	-spike --isa=rv32i --ic=1:2:128 --dc=2:2:64 /opt/riscv/riscv32-unknown-elf/bin/pk $(OBJ)

# generate a listing in $(OBJ).lst (without debug)
list:
	$(CC) -S $(CFLAGS) $(OBJ).c
	$(AS) -al $(OBJ).s > $(OBJ).lst
	-rm -f a.out

clean:
	-rm -f $(OBJ).lst $(OBJ) $(OBJ).s $(OBJ).o $(OBJ) $(OBJ).o $(OBJ).s
	rm -rf firmware.elf firmware.hex testbench testbench.vcd gtkwave.log
	rm -rf disasm.o disasm.s checks/ cexdata/ obj_dir
	rm -rf *.log *.asc *.json *.result *.vcd firmware.s *.tgz *.out

%.out: %.hex $(SOURCES)
	cp $*.hex firmware.hex
	python testbench.py testbench.sv

%.json: %.sv
	yosys -s $*.yosys -l $*-yosys.log

%.elf: %.s 
	$(TOOLCHAIN_PREFIX)gcc -march=rv32i -mabi=ilp32 -Os -Wall -Wextra -Wl,-Bstatic,-T,sections.lds,--strip-debug -ffreestanding -nostdlib -o $@ $^

%.hex: %.elf
	$(TOOLCHAIN_PREFIX)objcopy -O verilog $< $@

rundocker:
	$(RDOCKER)