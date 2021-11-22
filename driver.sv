`include "GBP_iface.sv"
`include "instruction.sv"

class driver;

  virtual GBP_iface ifc;
  mailbox #(instruction) gen2drv;

  function new(virtual GBP_iface ifc, mailbox #(instruction) g2d);
    this.ifc = ifc;
    this.gen2drv = g2d;
  endfunction : new

  task run();

    instruction instr;
    string s;
    
    $timeformat(-9,0," ns" , 10);
    s = $sformatf("[%t | DRV] I will start driving for the coverage test", $time);
    $display(s);
    
    forever begin
      
      int instrInMailbox = this.gen2drv.try_get(instr);
      
      @(negedge this.ifc.clock);
      if(instrInMailbox) begin
        this.ifc.valid <= 1;
        this.ifc.instr <= instr.instruction;
        $display("[%t | DRV] instruction passed to ifc: %s", $time, instr.toString());
        //Test if setup works when valid signal drops to zero => it works! :)
        @(negedge this.ifc.clock);
        this.ifc.valid <= 0;
        repeat (3) @(negedge this.ifc.clock);

      end else begin
        this.ifc.valid <= 0;
        $display("[%t | DRV] no instruction in mailbox", $time);
      end
    end

    $display("[DRV] ... done");
  
  endtask : run

  task reset();
        @(negedge this.ifc.clock);
        this.ifc.rst <= 1;
        @(negedge this.ifc.clock);
        this.ifc.rst <= 0;
        @(negedge this.ifc.clock);
        $display("[%t | DRV] Reset executed", $time);
    endtask : reset
endclass : driver
















































































































































