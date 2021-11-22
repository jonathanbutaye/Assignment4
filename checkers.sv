//`include "transaction.sv"
//`include "transaction_old.sv"
`include "instruction.sv"
`include "GbProcModel.sv"

class checkers;

  mailbox #(instruction) gen2che;
  mailbox #(probe) mon2che;
  mailbox #(byte) che2scb;
  gameboyprocessor model;

  function new(mailbox #(instruction) g2c, mailbox #(instruction) m2c, mailbox #(byte) c2s);
    this.gen2che = g2c;
    this.mon2che = m2c;
    this.che2scb = c2s;
  endfunction : new

  task run; 
    transaction expected_result;
    transactionOld received_result;

    forever begin  
      this.mon2che.get(received_result);
      this.gen2che.get(expected_result);

      if (expected_result.Z == received_result.Z)
      begin
        if (expected_result.flags_out == received_result.flags_out)
        begin
          this.che2scb.put(byte'(1));
        end else begin
          this.che2scb.put(byte'(0));
          $display("\n[%t | CHE] unsuccesful => FLAGS WRONG", $time);
          $display("Received: %s", received_result.toString());
          $display("Expected: %s", expected_result.toString());
        end
      end else begin
        this.che2scb.put(byte'(0));
        $display("\n[%t | CHE] unsuccesful => RESULT WRONG", $time);
        $display("Received: %s", received_result.toString());
        $display("Expected: %s", expected_result.toString());
      end
    end
  endtask
  
endclass : checkers
