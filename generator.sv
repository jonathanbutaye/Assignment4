//`include "transaction.sv"
`include "instruction.sv"

class generator;

  mailbox #(instruction) gen2drv;
  mailbox #(instruction) gen2che;
  instruction instr;

  function new(mailbox #(instruction) g2d, mailbox #(instruction) g2c);

    this.gen2drv = g2d;
    this.gen2che = g2c;

  endfunction : new

  task run;

  for(int i=0; i<100; i++)
  //forever begin
    begin
      this.instr = new();
      this.tra.instruction_constraint.constraint_mode(1);
      void'(this.instr.randomize());
      void'(this.gen2drv.try_put(this.tra));
      void'(this.gen2che.try_put(this.tra));
    end
    
  endtask : run

endclass : generator


