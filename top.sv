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
    
    //Coverpoint for the operations ADC SBC and CP
    cpOperationsAdcSbcCp: coverpoint theInterface.instr[7:3]
    iff(theInterface.valid) {
      bins ADC = {5'b10001};
      bins SBC = {5'b10011};
      bins CP = {5'b10111};
    }
    
    
    //The f register of the ALU is the lower half of the probe ([7:0]), 
    //the flags are in the higher half of register f so the carry in flag is probe[4]
    cpCarryInFlagSet: coverpoint theInterface.probe[4]
    iff(theInterface.valid) {
      bins carryInFlagSet = {'b1};
    }

    //Cross coverpoint between the the two coverpoints above
    cpOperationsAndCarry: cross cpOperationsAdcSbcCp, cpCarryInFlagSet {
      bins carryInADC = binsof(cpOperationsAdcSbcCp.ADC) && binsof(cpCarryInFlagSet);
    }

  endgroup

  cg1 cg_inst = new;


endmodule : top

`endif
