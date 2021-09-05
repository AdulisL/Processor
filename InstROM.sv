// Create Date:    15:50:22 10/02/2019 
// Design Name: 
// Module Name:    InstROM 
// Project Name:   CSE141L
// Tool versions: 
// Description: Verilog module -- instruction ROM template	
//	 preprogrammed with instruction values (see case statement)
//
// Revision: 2021.08.08
// instructions are 9 bits wide
// change A from default of 10 if you need <513 or >1024 instructions
module InstROM #(parameter A=10, W=9) (
  input  [A-1:0] InstAddress,
  output logic[W-1:0] InstOut
  );

// declare 2-dimensional array, W bits wide, 2**A words deep
  logic[W-1:0] inst_rom[2**(A)];
  always_comb InstOut = inst_rom[InstAddress];

// need $readmemh or $readmemb to initialize all of the elements
  initial begin		   // load from external text file
  	$readmemb("test.txt", inst_rom);
  end 
  
endmodule
