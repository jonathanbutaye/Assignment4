`include "ALU_iface.sv"
`include "transaction.sv"
`include "transaction_old.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "checkers.sv"
`include "scoreboard.sv"

class environment;

  mailbox #(transaction) gen2drv;
  mailbox #(transaction) gen2che;
  mailbox #(transactionOld) mon2che;
  mailbox #(byte) che2scb;

  virtual ALU_iface ifc;

  generator gen;
  driver drv;
  monitor mon;
  checkers che;
  scoreboard scb;

  function new(virtual ALU_iface ifc);
    this.ifc = ifc;

    this.gen2drv = new(2200);
    this.gen2che = new(2200);
    this.mon2che = new(2200);
    this.che2scb = new(2200);

    this.gen = new(this.gen2drv, this.gen2che);
    this.drv = new(ifc, this.gen2drv);
    this.mon = new(ifc, this.mon2che);
    this.che = new(this.gen2che, this.mon2che, this.che2scb);
    this.scb = new(this.che2scb);
  endfunction : new

  task run();
    fork
      /* start the upstream **********************/
      fork
        this.mon.run();
        this.drv.run_addition();
        this.che.run();
      join_none;

      /* wait for some spin up *******************/
      repeat (10) @(posedge this.ifc.clock);

      /* start the downstream ********************/
      fork
        this.gen.run();
        this.scb.run(2100);
      join

      /* wait for some spin down *****************/
      repeat (10) @(posedge this.ifc.clock);

      // terminate threads
      disable fork;
    join;

    this.scb.showReport();
    
    $stop;

  endtask : run

endclass : environment

