
`ifndef SV_IFC_GBP
`define SV_IFC_GBP

interface GBP_iface ( 
  input logic clock
);

  logic rst;
  logic [7:0] instr;
  logic valid;
  logic [15:0] probe;

endinterface

`endif