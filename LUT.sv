// CSE141L
// possible lookup table for PC target
// leverage a few-bit pointer to a wider number
// Lookup table acts like a function: here Target = f(Addr);
//  in general, Output = f(Input);
import LUT_def::*; 
module LUT(
  input       [ 2:0] Addr, // Will be given where to branch
  output logic[ 9:0] Target
  );

  always_comb begin
    Target = 10'h001;	   // default to 1 (or PC+1 for relative)
    case(Addr)		   
      3'b000:  Target = 10'h3fd;  // = -3, move back 16 lines of machine code
      3'b001:  Target = 10'h3fb;  // -5, move back 16 lines of machine code
      3'b010:	 Target = 10'h003;  // +3, 3 lines move forward
      3'b011:	 Target = 10'h007;  // +7, 7 lines
    endcase
  end
// always_comb begin
//   Target = kLookupTable[lut_type][key];
// end

// always_comb 
//   case(Addr)		   //-16'd30;
// 	// LUT_SW:    Target = 10'h3ff;  // -1
// 	// LUT_BEQ:	  Target = 10'h003;

// 	default: Target = 10'h001;
//   endcase

endmodule