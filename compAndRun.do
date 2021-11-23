echo "creating 'work' lib"
vlib work

echo "compile verification classes"
vlog -sv top.sv 
vlog -sv environment.sv 
vlog -sv checkers.sv 
vlog -sv scoreboard.sv 
vlog -sv generator.sv 
vlog -sv instruction.sv 
vlog -sv probe.sv 
vlog -sv monitor.sv 
vlog -sv GBP_iface.sv 
vlog -sv GbProcModel.sv 
vlog -sv test.sv 

echo "compile 'DUT'"
vcom ALU.vhd
vcom gbprocessor.vhd

vsim top
run 1 ms
coverage report -details