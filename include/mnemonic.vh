// integer
parameter ADDx = 7'b000_0000;
parameter SUBx = 7'b000_0001;
parameter MULx = 7'b000_0010;
parameter DIVx = 7'b000_0011;
parameter CMPx = 7'b000_0100;
parameter ABSx = 7'b000_0101;
parameter ADCx = 7'b000_0110;
parameter SBCx = 7'b000_0111;

// shift
parameter SHLx = 7'b000_1000;
parameter SHRx = 7'b000_1001;
parameter ASHx = 7'b000_1010;

// rotate
parameter ROLx = 7'b000_1100;
parameter RORx = 7'b000_1101;

// logic
parameter AND  = 7'b001_0000;
parameter OR   = 7'b001_0001;
parameter NOT  = 7'b001_0010;
parameter XOR  = 7'b001_0011;

// set
parameter SETL = 7'b001_0110;
parameter SETH = 7'b001_0111;

// load
parameter LD   = 7'b001_1000;

// store
parameter ST   = 7'b001_1001;

// branch
parameter J    = 7'b001_1100;
parameter JA   = 7'b001_1101;

// other
parameter NOP  = 7'b001_1110;
parameter HLT  = 7'b001_1111;

