// This file defines the parameters used in the alu
package ALU_def;
    typedef enum logic [2:0]{
	// R-type (bit 8:6 Opcode)
       ADD	,   // 000
	   XOR	,	// 001
	   SHIFT,   // 010
	   AND	,	// 011
	// I-type (bit 8:6 Opcode)
	   LW	,	// 100
	   SW	,	// 101
	   BNE	,	// 110
	   STP		// 111
    } ALU_CTRL;
	

endpackage