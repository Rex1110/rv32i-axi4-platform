`define R_type 7'b0110011
`define NOP  6'b000000
`define ADD  6'b000001
`define SUB  6'b000010
`define SLL  6'b000011
`define SLT  6'b000100
`define SLTU 6'b000101
`define XOR  6'b000110
`define SRL  6'b000111
`define SRA  6'b001000
`define OR   6'b001001
`define AND  6'b001010

`define I_type 7'b0010011
`define ADDI  6'b001011
`define SLTI  6'b001100
`define SLTIU 6'b001101
`define XORI  6'b001110
`define ORI   6'b001111
`define ANDI  6'b010000
`define SLLI  6'b010001
`define SRLI  6'b010010
`define SRAI  6'b010011

`define L_type 7'b0000011
`define LB   6'b010100
`define LH   6'b010101
`define LW   6'b010110
`define LBU  6'b010111
`define LHU  6'b011000

`define S_type 7'b0100011
`define SB   6'b011001
`define SH   6'b011010
`define SW   6'b011011

`define LUI_type 7'b0110111
`define LUI   6'b011100
`define AUIPC_type 7'b0010111
`define AUIPC 6'b011101
`define JAL_type 7'b1101111
`define JAL   6'b011110
`define JALR_type 7'b1100111
`define JALR  6'b011111

`define B_type 7'b1100011
`define BEQ  6'b100000
`define BNE  6'b100001
`define BLT  6'b100010
`define BGE  6'b100011
`define BLTU 6'b100100
`define BGEU 6'b100101

`define CSR_type 7'b1110011
`define RDINSTRETH  6'b100110
`define RDINSTRET   6'b100111
`define RDCYCLEH    6'b101000
`define RDCYCLE     6'b101001