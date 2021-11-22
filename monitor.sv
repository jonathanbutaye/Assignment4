
`include "probe.sv"

class monitor;

  virtual GBP_iface ifc;
  mailbox #(probe) mon2che;

  function new(virtual GBP_iface ifc, mailbox #(probe) m2c);
    this.ifc = ifc;
    this.mon2che = m2c;
  endfunction : new

  task run();
    probe probe;
    byte valid;

    forever begin
      @(negedge this.ifc.clock);
      valid = this.ifc.valid;
      if (valid) begin
          probe = new(this.ifc.probe);
          $display("[%t | MON] Recieved: %s", $time, probe.toString());
          mon2che.put(probe);
      end
    end
  endtask : run

endclass : monitor
