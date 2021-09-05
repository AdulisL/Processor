// Create Date:    2018.04.05
// Design Name:    BasicProcessor
// Module Name:    TOpcodeLevel 
// CSE141L
// partial only	
import Definitions::*;								   
module TopLevel(		   // you will have the same 3 ports
    input        Reset,	   // init/reset, active high
			     Start,    // start next program
	             Clk,	   // clock -- posedge used inside design
    output logic Ack	   // done flag from DUT
    );
OP_enum ALU_type;
wire [ 2:0] Opcode;
wire [ 9:0] PgmCtr, PCTarg; // program counter & forwarding/backwarding PgmCtr

wire [ 2:0] TargSel;	   // to extract branch location, PCTag in LUT
wire [ 8:0] Instruction;   // our 9-bit Opcodecode
wire [ 7:0] ReadA, ReadB;  // reg_file outputs
wire [ 7:0] InA, InB; 	   // ALU Opcodeerand inputs
wire [ 7:0] ALU_out;	   // ALU result from optands
wire [ 7:0] RegWriteValue, // data in to reg file
            MemWriteValue, // data in to data_memory
	   	    MemReadValue;  // data out from data_memory   
wire        MemWriteEn,	   // data_memory write enable
			RegWrEn,
			LoadInst,	   // reg_file write enable
            BranchEn,	   // to program counter: branch enable
			Parity,		   // parity of ALU output 
			Odd,		   // ALU output[0]
			Zero;		   // ALU output = 0 flag
logic[15:0] CycleCt;	   // standalone; NOT PC!

assign Opcode = Instruction[8:6];

always_comb begin
	ALU_type = OP_enum'(Opcode);
end
// Fetch stage = Program Counter + Instruction ROM
  ProgCtr PC1 (		             // this is the program counter module
	.Reset        (Reset   ) ,   // reset to 0
	.Start        (Start   ) ,   // SystemVerilog shorthand for .grape(grape) is just .grape 
	.Clk          (Clk     ) ,   //    here, (Clk) is required in Verilog, optional in SystemVerilog
	.BranchEn     (Odd     ) ,   // input branch enable
    .Target       (PCTarg  ) ,   // input "how far?" during a branch
	.ProgCtr      (PgmCtr  )	 // output program count = index to instruction memory
	);

//Control decoder
  Ctrl Ctrl1 (
	.Opcode  	  (Opcode),			  // input instruction
	.Instruction  (Instruction),  // input from instr_ROM
	.BranchEn     (BranchEn   ),  // output to PC
	.RegWrEn      (RegWrEn    ),  // output register file write enable
	.MemWrEn      (MemWriteEn ),  // output data memory write enable
    .LoadInst     (LoadInst   ),  // output swich b/n ALU_out & MemReadValue
    .PCTarg       (TargSel    ),  // output to extract branch PCTag in LUT
    .Ack          (Ack        )	  // output "done" flag
  );
// Lookup table to handle 10-bit program counter jumps w/ only 2 bits
LUT LUT1(
	.Addr    (TargSel),
    .Target  (PCTarg) // output
    );

// instruction ROM
 InstROM #(.W(9)) IR1(
	.InstAddress  (PgmCtr),  		// input, for fetching next instruction
	.InstOut      (Instruction)		// output, next instruction
);


// reg file
RegFile #(.W(8),.D(4)) RF1 (
		.Clk    				,
		.RegWriteEn(RegWrEn)    , 
		//concatenate with 0 to give us 4 bits reg-address
		.RaddrA    ({1'b0,Instruction[5:3]}),  // input address reg_a
		.RaddrB    ({1'b0,Instruction[2:0]}),  // input address reg_b
		.Waddr     ({1'b0,Instruction[5:3]}),  // input address reg_write
		.DataIn    (RegWriteValue), 		   // input content reg_write
		.DataOutA  (ReadA), 				   // output content reg_a
		.DataOutB  (ReadB)					   // output content reg_b
);
// one pointer, two adjacent read accesses: (Opcodetional approach)
//	.raddrA ({Instruction[5:3],1'b0});
//	.raddrB ({Instruction[5:3],1'b1});

    assign InA = ReadA;	      // connect RF out to ALU in
	assign InB = ReadB;
	assign RegWriteValue = LoadInst? MemReadValue : ALU_out;  // 2:1 switch into reg_file
	
    
ALU ALU1  (
	  .OP     (Opcode), // input ALU instruction 
	  .InputA  	 (InA),		 // input RegA_adrs
	  .InputB    (InB), 	 // input RegB_adrs 
	  .Out       (ALU_out),	 // output RegWriteValue
	  .Zero    	 (Zero),	 // output ALU flag for Branch
	  .Parity    (Parity),	 // output ^ALU_out
	  .Odd       (Odd)
 );
  
assign MemWriteValue = ALU_out;  // 2:1 switch into reg_file
DataMem DM1(
		.Clk          (Clk)			 ,
		.Reset		  (Reset)		 ,
		.DataAddress  (ReadA)	 	 , 	// input ReadA data in address
		.WriteEn      (MemWriteEn)	 , 	// input data memory write enabled 
		.DataIn       (MemWriteValue), 	// input data to memory 
		.DataOut      (MemReadValue)    // output, data to read from memory
);

// count number of instructions executed
always_ff @(posedge Clk)
  if (Start == 1)	   // if(start)
  	CycleCt <= 0;
  else if(Ack == 0)   // if(!halt)
  	CycleCt <= CycleCt + 16'b1;

endmodule