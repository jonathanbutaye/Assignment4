`ifndef SV_PROBE
`define SV_PROBE

class probe;
    byte A;
    byte F;

    function new(byte a, byte f);
        this.A = probe[15:8];
        this.F = probe[7:0];
    endfunction 

    function string toString();
        return $sformatf("A: %02x, F: %02x", this.A, this.F);          
    endfunction

endclass 

`endif