parameter WORD = 32;
parameter ADDR = 16;

// instruction decode
parameter OPC_MSB = 31;
parameter OPC_LSB = 25;
parameter W_OPC = 1 + OPC_MSB - OPC_LSB;

parameter IMMF_BIT = 24;

parameter RD_MSB = 23;
parameter RD_LSB = 20;
parameter W_RD = 1 + RD_MSB - RD_LSB;

parameter RS_MSB = 19;
parameter RS_LSB = 16;
parameter W_RS = 1 + RS_MSB - RS_LSB;

parameter IMM_MSB = 15;
parameter IMM_LSB = 0;
parameter W_IMM = 1 + IMM_MSB - IMM_LSB;

parameter W_DOPC = 6;

