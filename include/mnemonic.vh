`ifndef _mnemonic_vh_
`define _mnemonic_vh_

// integer
`define ADDx 7'b000_0000
`define SUBx 7'b000_0001
`define MULx 7'b000_0010
`define DIVx 7'b000_0011
`define CMPx 7'b000_0100
`define ABSx 7'b000_0101
`define ADCx 7'b000_0110
`define SBCx 7'b000_0111

// shift
`define SHLx 7'b000_1000
`define SHRx 7'b000_1001
`define ASHx 7'b000_1010

// rotate
`define ROLx 7'b000_1100
`define RORx 7'b000_1101

// logic
`define AND  7'b001_0000
`define OR   7'b001_0001
`define NOT  7'b001_0010
`define XOR  7'b001_0011

// set
`define SETL 7'b001_0110
`define SETH 7'b001_0111

// load
`define LD   7'b001_1000

// store
`define ST   7'b001_1001

// branch
`define J    7'b001_1100
`define JA   7'b001_1101

// other
`define NOP  7'b001_1110
`define HLT  7'b001_1111

`endif // _mnemonic_vh_

