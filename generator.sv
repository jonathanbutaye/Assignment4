`include "transaction.sv"

class generator;

  mailbox #(transaction) gen2drv;
  mailbox #(transaction) gen2che;
  transaction tra;

  function new(mailbox #(transaction) g2d, mailbox #(transaction) g2c);

    this.gen2drv = g2d;
    this.gen2che = g2c;

  endfunction : new

  task run;
    //generate the transactions for the test with the correct constrains
    generateTransaction(800, 0);
    for(int i=1; i<4; i++) generateTransaction(100, i);
    generateTransaction(1000, 4);
  endtask : run

  function void generateTransaction(int NoT, int constr);
    for(int i=0; i<NoT; i++)
    begin
      this.tra = new();
      activateCorrectConstraints(constr);
      void'(this.tra.randomize());
      void'(this.tra.calculateFlagsAndZ);
      void'(this.gen2drv.try_put(this.tra));
      void'(this.gen2che.try_put(this.tra));
    end
  endfunction : generateTransaction

  function void activateCorrectConstraints(int number);
    //Set off all constrains
    this.tra.c0.constraint_mode(0);
    this.tra.c1.constraint_mode(0);
    this.tra.c2.constraint_mode(0);
    this.tra.c3.constraint_mode(0);
    this.tra.c4.constraint_mode(0);
    
    //Activate the right constraint
    case (number)
        0 : this.tra.c0.constraint_mode(1);
        0 : this.tra.c1.constraint_mode(1);
        0 : this.tra.c2.constraint_mode(1);
        0 : this.tra.c3.constraint_mode(1);
        0 : this.tra.c4.constraint_mode(1);
        default : ;
    endcase
  endfunction
endclass : generator


