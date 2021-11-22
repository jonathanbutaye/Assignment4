`include "GBP_iface.sv"
`include "environment.sv"

module test(GBP_iface ifc);

  environment env = new(ifc);

  initial
  begin
    env.run();
  end

endmodule : test

