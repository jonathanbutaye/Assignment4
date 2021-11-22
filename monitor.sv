`include "transaction.sv"
`include "transaction_old.sv"

class monitor;

  virtual ALU_iface ifc;
  mailbox #(transactionOld) mon2che;

  function new(virtual ALU_iface ifc, mailbox #(transactionOld) m2c);
    this.ifc = ifc;
    this.mon2che = m2c;
  endfunction : new

  task run();
    
    transactionOld tra;

    forever begin
      @(negedge this.ifc.clock);
        //create a transaction to pass to the checkers class object
        //format to create new transaction: function new(byte A, byte B, bit[3:0] flags_in, bit[2:0] operation, byte Z, bit[3:0] flags_out);
        tra = new(this.ifc.data_a, this.ifc.data_b, this.ifc.flags_in, this.ifc.operation, this.ifc.data_z, this.ifc.flags_out);
        if (tra.A || tra.B || tra.flags_in || tra.operation) begin
          this.mon2che.put(tra);
        end
    end /* forever */
  endtask : run

endclass : monitor
