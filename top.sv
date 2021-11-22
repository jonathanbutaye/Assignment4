`ifndef TOP
`define TOP

`include "GBP_iface.sv"
`include "test.sv"

module top;
  logic clock=0;

  // clock generation - 100 MHz
  always #5 clock = ~clock;

  // instantiate an interface
  GBP_iface theInterface (
    .clock(clock)
  );

  // instantiate the DUT and connect it to the interface
  gbprocessor dut (

    .reset(theInterface.rst),
    .clock(theInterface.clock),
    .instruction(theInterface.instr),
    .valid(theInterface.valid),
    .probe(theInterface.probe)

    );

  // SV testing 
  test tst(theInterface);

endmodule : top

`endif
