
package ControlUnit_def;
    typedef enum{
       ADD = 0,
	   XOR = 1,
	   SHIFT = 2,
	   AND = 3,
	   LW = 4,
	   SW = 5,
	   BEQ = 6,
	   STP = 7
    } Opcode;

    // typedef enum logic[1:0] {
    //    R, I
    // } InstType;

endpackage