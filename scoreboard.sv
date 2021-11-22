class scoreboard;

  mailbox #(byte) che2scb;

  int NO_tests;
  int no_tests_done;
  int no_tests_ok;
  int no_tests_nok;

  function new(mailbox c2s);
    this.che2scb = c2s;
    NO_tests = 0;
    no_tests_done = 0;
    no_tests_ok = 0;
    no_tests_nok = 0;
  endfunction : new


  task run(int NOT);
    byte result;
    this.NO_tests = NOT;

    while (this.no_tests_done < this.NO_tests)
    begin
      this.che2scb.get(result);

      no_tests_done++; 
      
      if (result > 0)
      begin 
        no_tests_ok++; 
        $display("[SCB] successful test registered, count = %0d", no_tests_ok);
      end else begin
        no_tests_nok++;
        $display("[SCB] unsuccessful test registered");
      end
    end /* while*/
  endtask : run


  task showReport;
    $display("[SCB] Test report");
    $display("[SCB] ------------");
    $display("[SCB] # tests done         : %0d", this.no_tests_done);
    $display("[SCB] # tests ok           : %0d", this.no_tests_ok);
    $display("[SCB] # tests failed       : %0d", this.no_tests_nok);
    $display("[SCB] # tests success rate : %0.2f", 100.0*this.no_tests_ok/this.no_tests_done);
  endtask : showReport

endclass : scoreboard
