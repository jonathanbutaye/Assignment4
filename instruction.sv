`ifndef SV_INSTRUCTION
`define SV_INSTRUCTION

class instruction;
    rand byte instruction;

    //constraint for ADD, ADC
    constraint instruction_constraint {
        //Fixate the 2 msb from the instruction to 10
        (instruction[7:6] inside {'b10});
    }
    
    function new();
        this.instruction = 0;
    endfunction 

    function string toString();
        return $sformatf("Instruction: %02x", this.instruction);          
    endfunction
endclass 

`endif