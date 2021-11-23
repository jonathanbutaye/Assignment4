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

  covergroup cg1 @(posedge clock);
    option.at_least = 500;

    cpADC: coverpoint theInterface.instr[7:3]

    iff(theInterface.valid) {
      bins ADC = {5'b10001};
    }

  endgroup

  cg1 cg_inst = new;


endmodule : top

`endif
