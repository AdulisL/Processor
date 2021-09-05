import Definitions::*;
module ALU(
  input [2:0] OP,
  input [7:0] InputA, InputB,
  // input clk,
  output logic [7:0] Out,
  // output logic cout,
  output logic Zero,
               Parity,
               Odd
);
  OP_enum ALU_type;

  assign Zero   = !Out;           // reduction NOR
  assign Parity = ^Out;           // reduction XOR
  assign Odd    = Out[0];				  // odd/even -- just the value of the LSB
  
  always_comb begin
    unique case (OP)
      R_ADD:    Out = InputA +  InputB;
      R_XOR:    Out = InputA ^ InputB;
      R_SHIFT:  Out = InputA << 1;
      R_AND:    Out = InputA &  InputB;
    default:  Out = 0;
    endcase
    // Zero = Out == 0;
    ALU_type = OP_enum'(OP);			 // displays operation name in waveform viewer
  end
 
  
  // always_comb							  // assign Zero = !Out;
  //   case(Out)
  //     'b0   : Zero = 1'b1;
	//   default : Zero = 1'b0;
  //   endcase
endmodule