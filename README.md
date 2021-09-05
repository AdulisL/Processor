# Lab 4 - How to Run Our Processor
## CSE 141L Summer Session 2
### Meron Asfaw, Anahita Afshari
Our processor compiles and works in ModelSim, and we have included PDFs (RTL_Viewer.pdf) to view the structure.

We had issues with our programs; because we created a very minimal instruction set architecture, we had issues then translating our C code, which is the basis of our encryption and decryption algorithms. 

We have a working assembler that for the most part, should translate assembly instructions into machine code according to our architecture (it works by inputting an input text file, then creates a corresponding machine code text file with just the name and "_mach" at the end), but we have not gotten an algorithm written entirely in assembly instructions to work. For our processor to use the machine code, it needs to be located in the ModelSim folder.

We also had trouble utilizing our lookup table, which we needed to rely on heavily given the few registers we could use in our load/store structure.

[Documentation](https://docs.google.com/document/d/1zPGzerhKU82PL_rC6OqJes_wkMp9okdTKpOyBXOiYU8/edit?usp=sharing)