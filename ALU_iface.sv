
`ifndef SV_IFC_ALU
`define SV_IFC_ALU

interface ALU_iface ( 
  input logic clock
);

  logic reset;
  logic [7:0] instruction;
  logic valid;
  logic [15-1:0] probe;
  
endinterface

`endif