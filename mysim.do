vsim -voptargs="+acc" work.testbench_single

view wave
add wave -r sim:/testbench_single/*

view list
add list sim:/testbench_single/clk
add list sim:/testbench_single/reset
add list sim:/testbench_single/pc
add list sim:/testbench_single/instr
add list sim:/testbench_single/dut/pc
add list sim:/testbench_single/dut/instr
add list sim:/testbench_single/dut/aluout
add list sim:/testbench_single/dut/memwrite
add list sim:/testbench_single/dut/readdata
add list sim:/testbench_single/dut/writedata
add list sim:/testbench_single/dut/myreg/regs[1]
add list sim:/testbench_single/dut/myreg/regs[2]
add list sim:/testbench_single/dut/myreg/regs[5]
add list sim:/testbench_single/dut/myreg/regs[6]
add list sim:/testbench_single/dut/myreg/regs[7]
add list sim:/testbench_single/dut/myreg/regs[10]
add list sim:/testbench_single/dut/alu/result

run 5000ns
