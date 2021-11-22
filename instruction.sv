`ifndef SV_INSTRUCTION
`define SV_INSTRUCTION

class instruction;
    rand byte instruction;

    constraint instruction_constraint {
        (instruction[7:4] inside {'h8, 'h9});
    }
    
    function new();
        this.instruction = 0;
    endfunction 
endclass 

`endif