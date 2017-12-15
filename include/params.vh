`ifndef _params_vh_
`define _params_vh_

`define WORD 32
`define ADDR 16

// instruction decode
`define OPC_MSB 31
`define OPC_LSB 25
`define W_OPC (1 + `OPC_MSB - `OPC_LSB)

`define IMMF_BIT 24

`define RD_MSB 23
`define RD_LSB 20
`define W_RD (1 + `RD_MSB - `RD_LSB)

`define RS_MSB 19
`define RS_LSB 16
`define W_RS (1 + `RS_MSB - `RS_LSB)

`define IMM_MSB 15
`define IMM_LSB 0
`define W_IMM (1 + `IMM_MSB - `IMM_LSB)

`define W_DOPC 12

`define W_STATUS      6
`define ZERO_BIT      5
`define POSITIVE_BIT  4
`define NEGATIVE_BIT  3
`define CARRY_BIT     2
`define OVERFLOW_BIT  1
`define UNDERFLOW_BIT 0

`define REG_S 16

`define W_CC 3

`endif // _params_vh_

