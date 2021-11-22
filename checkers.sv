
`include "instruction.sv"
`include "probe.sv"
`include "GbProcModel.sv"

class checkers;

  mailbox #(instruction) gen2che;
  mailbox #(probe) mon2che;
  mailbox #(byte) che2scb;
  gameboyprocessor model;

  function new(mailbox #(instruction) g2c, mailbox #(probe) m2c, mailbox #(byte) c2s, gameboyprocessor model);
    this.gen2che = g2c;
    this.mon2che = m2c;
    this.che2scb = c2s;
    this.model = model;
  endfunction : new

  task run; 
    instruction executed_instruction;
    probe received_result;

    forever begin  
      this.mon2che.get(received_result);
      this.gen2che.get(executed_instruction);
      this.model.executeALUInstruction(executed_instruction.instruction);

      if (this.model.F == received_result.F && this.model.A == received_result.A)
      begin
        this.che2scb.put(byte'(1));
      end else begin
        this.che2scb.put(byte'(0));
        $display("\n[%t | CHE] unsuccesful", $time);
        $display("Received: %s", received_result.toString());
        model.toString;
      end
    end
  endtask
  
endclass : checkers
