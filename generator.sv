
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
    //used a normal for loop because forever begin gave some problems
    for(int i=0; i<100000000; i++) begin
      this.instr = new();
      this.instr.instruction_constraint.constraint_mode(1);
      void'(this.instr.randomize());
      void'(this.gen2drv.try_put(this.instr));
      void'(this.gen2che.try_put(this.instr));
    end
    
  endtask : run

endclass : generator


