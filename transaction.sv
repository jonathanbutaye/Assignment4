`ifndef ALU_TRAN
`define ALU_TRAN


class transaction;

  rand byte A;
  rand byte B;
  byte Z;
  rand bit [2:0] operation;
  rand bit [3:0] flags_in;
  bit [3:0] flags_out;

  //constraint voor 100 testen elk van ADD, ADC, SUB, SBC, AND, XOR, OR, CP
  constraint c0 {
      operation dist { [0:7] := 1 };
  }

  //constraint voor 100 testen SUB met B < A
  constraint c1 {
      operation == 3'b10;
      unsigned'(B) < unsigned'(A);
  }

  //constraint voor 100 testen XOR met B = 0x55
  constraint c2 {
      operation == 3'b101;
      B == 'h55;
  }

  //constraint voor 100 testen ADC en de inputcarry = 1
  constraint c3 {
      operation == 3'b001;
      flags_in[0] == 1'b1;
  }

  //constraint voor 1000 testen met 20% operatie CP en 80% andere operaties
  constraint c4 {
      operation dist { 7 := 2, [0:6] := 8 };
  }
  
  //Functie die Z en de output flags berekent op basis van de inputs
  function void calculateFlagsAndZ();
    shortint a, b, z;
    a = unsigned'(this.A);
    b = unsigned'(this.B);
    
    case (operation)
        3'b000 : begin  //ADD
            z = (a + b) % 256;
            this.flags_out[3] = ((z==0) ? 1'b1 : 1'b0);                     //if instruction results in zero this flag is 1
            this.flags_out[2] = 1'b0;                                       //0 because ADD
            this.flags_out[1] = ((((a%16) + (b%16)) > 15) ? 1'b1 : 1'b0);   //HCF (half carry flag) 
            this.flags_out[0] = (((a + b) > z) ? 1'b1 : 1'b0 );             //CF (carry flag)
        end
        3'b001 : begin  //ADC
            z = (a + b + this.flags_in[0]) % 256;
            this.flags_out[3] = ((z==0) ? 1'b1 : 1'b0);                             //if instruction results in zero this flag is 1
            this.flags_out[2] = 1'b0;                                               //0 because ADC
            this.flags_out[1] = ((((a%16) + (b%16) + this.flags_in[0]) > 15) ? 1'b1 : 1'b0);           //HCF (half carry flag) 
            this.flags_out[0] = (((a + b + this.flags_in[0]) > z) ? 1'b1 : 1'b0 );  //CF (carry flag)
        end
        3'b010 : begin  //SUB
            z = (a - b) % 256;
            this.flags_out[3] = ((z==0) ? 1'b1 : 1'b0);                             //if instruction results in zero this flag is 1
            this.flags_out[2] = 1'b1;                                               //1 because SUB
            this.flags_out[1] = (((a%16) < (b%16)) ? 1'b1 : 1'b0);                  //HCF (half carry flag) 
            this.flags_out[0] = ((a < b) ? 1'b1 : 1'b0 );                            //CF (carry flag)
        end
        3'b011 : begin  //SBC
            z = (a - b - this.flags_in[0]) % 256;
            this.flags_out[3] = ((z==0) ? 1'b1 : 1'b0);                             //if instruction results in zero this flag is 1
            this.flags_out[2] = 1'b1;                                               //1 because SBC
            this.flags_out[1] = (((a%16) < (b%16 + this.flags_in[0])) ? 1'b1 : 1'b0); //HCF (half carry flag) 
            this.flags_out[0] = ((a < b + this.flags_in[0]) ? 1'b1 : 1'b0 );         //CF (carry flag)
        end
        3'b100 : begin  //AND
            z = a & b;
            this.flags_out[3] = ((z==0) ? 1'b1 : 1'b0);                             //if instruction results in zero this flag is 1
            this.flags_out[2] = 1'b0;                                               //0 because AND
            this.flags_out[1] = 1'b1;                                               //HCF (half carry flag) 
            this.flags_out[0] = 1'b0;                                               //CF (carry flag)
        end
        3'b101 : begin  //XOR
            z = a ^ b;
            this.flags_out[3] = ((z==0) ? 1'b1 : 1'b0);                             //if instruction results in zero this flag is 1
            this.flags_out[2] = 1'b0;                                               //0 because XOR
            this.flags_out[1] = 1'b0;                                               //HCF (half carry flag) 
            this.flags_out[0] = 1'b0;                                               //CF (carry flag)
        end
        3'b110 : begin  //OR
            z = a | b;
            this.flags_out[3] = ((z==0) ? 1'b1 : 1'b0);                             //if instruction results in zero this flag is 1
            this.flags_out[2] = 1'b0;                                               //0 because OR
            this.flags_out[1] = 1'b0;                                               //HCF (half carry flag) 
            this.flags_out[0] = 1'b0;                                               //CF (carry flag)
        end
        3'b111 : begin  //CP
            z = a;
            this.flags_out[3] = ((z==0) ? 1'b1 : 1'b0);                             //if instruction results in zero this flag is 1
            this.flags_out[2] = 1'b1;                                               //1 because CP
            this.flags_out[1] = (((a%16) < (b%16)) ? 1'b1 : 1'b0);                  //HCF (half carry flag) 
            this.flags_out[0] = ((a < b) ? 1'b1 : 1'b0 );                            //CF (carry flag)
        end
    endcase
    this.Z = byte'(z);
  endfunction
  
  
  function new();
    this.A = 0;
    this.B = 0;
    this.Z = 0;
    this.operation = 3'b0;
    this.flags_in = 4'b0;
    this.flags_out = 4'b0;
  endfunction : new

  function string toString();
    return $sformatf("A: %02x, B: %02x, flags_in: %01x, operation: %01x, Z: %02x, flags_out: %01x", this.A, this.B, this.flags_in, this.operation, this.Z, this.flags_out);
  endfunction : toString

endclass : transaction

`endif