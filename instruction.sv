`ifndef SV_INSTRUCTION
`define SV_INSTRUCTION

class instruction;
    rand byte instruction;

    //constraint for ADD, ADC
    constraint instruction_constraint {
        (instruction[7:4] inside {'h8});
    }
    
    function new();
        this.instruction = 0;
    endfunction 

    function string toString();
        return $sformatf("Instruction: %02x", this.instruction);          
    endfunction
endclass 

`endif