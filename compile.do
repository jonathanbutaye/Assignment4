echo "creating 'work' lib"
vlib work

echo "compile verification classes"
vlog -sv top.sv -cover bcestf
vlog -sv environment.sv -cover bcestf
vlog -sv checkers.sv -cover bcestf
vlog -sv scoreboard.sv -cover bcestf
vlog -sv generator.sv -cover bcestf
vlog -sv instruction.sv -cover bcestf
vlog -sv probe.sv -cover bcestf
vlog -sv monitor.sv -cover bcestf
vlog -sv GBP_iface.sv -cover bcestf
vlog -sv GbProcmodel.sv -cover bcestf
vlog -sv test.sv -cover bcestf

echo "compile 'DUT'"
vcom ALU.vhd
vcom gbprocessor.vhd