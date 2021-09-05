// control decoder (combinational, not clocked)
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
import Definitions::*;
module Ctrl (
  input [2:0] Opcode,
  input [8:0] Instruction,	 // machine code
  output logic BranchEn,
               RegWrEn,	 // write to reg_file (common)
			         MemWrEn, // write to mem (store only)
			         LoadInst, // mem or ALU to reg_file ?
			         Ack  ,    // "done w/ program"
  output logic[2:0] PCTarg
  // output logic[5:0] immediate
  );
  
OP_enum OP_enumoric;		// type enum: used for convenient waveform 

assign LoadInst  = (Opcode == 3'b100);    // load
assign MemWrEn   = (Opcode == 3'b101);	  // store
assign RegWrEn   = (Opcode != 3'b101);	  // all other ops
// branch every time instruction = 9'b110_??????;
assign BranchEn  = (Opcode == 3'b110);    // turns BEQ high
assign PCTarg    = Instruction[5:3];
// reserve instruction = 9'b111111111; for Ack
    
// branch every time ALU result LSB = 0 (even)
// assign BranchEn = &Opcode;
assign Ack = &Instruction;
always_comb
    OP_enumoric = OP_enum'(Opcode);			 // displays operation name in waveform viewer

endmodule