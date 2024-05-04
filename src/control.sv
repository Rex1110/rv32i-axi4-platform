`include "../include/define.svh"

module control(
    input           [31:0]  i_inst,

    output  logic           o_rd_wr,
    output  logic   [31:0]  o_imm,
    output  logic           o_ALUsrc1,
    output  logic           o_ALUsrc2,
    output  logic   [ 5:0]  o_mnemonic,

    output  logic           o_store,
    output  logic   [ 2:0]  o_funct3,
    output  logic           o_b_inst,
    output  logic           o_jal,
    output  logic           o_jalr,

    output  logic           o_DM_OE,

    output  logic   [ 4:0]  o_rd_addr,
    output  logic   [ 4:0]  o_rs1_addr,
    output  logic   [ 4:0]  o_rs2_addr
);
    logic [6:0] opcode;
    logic [2:0] funct3;
    assign opcode = i_inst[6:0];
    assign funct3 = i_inst[14:12];
    assign o_funct3 = i_inst[14:12];

    assign o_rd_addr  = i_inst[11:7];
    assign o_rs1_addr = i_inst[19:15];
    assign o_rs2_addr = i_inst[24:20];
    always_comb begin
        unique case (opcode)
            `R_type: begin
                o_rd_wr     = 1'b1;
                o_imm       = 32'b0;
                o_ALUsrc1   = 1'b1;
                o_ALUsrc2   = 1'b1;
                o_DM_OE     = 1'b0;
                o_store     = 1'b0;
                o_b_inst    = 1'b0;
                o_jal       = 1'b0;
                o_jalr      = 1'b0;
                unique case (funct3)
                    3'b000: o_mnemonic = i_inst[30] ? `SUB : `ADD;
                    3'b001: o_mnemonic = `SLL;
                    3'b010: o_mnemonic = `SLT;
                    3'b011: o_mnemonic = `SLTU;
                    3'b100: o_mnemonic = `XOR;
                    3'b101: o_mnemonic = i_inst[30] ? `SRA : `SRL; 
                    3'b110: o_mnemonic = `OR;
                    3'b111: o_mnemonic = `AND;
                    default:o_mnemonic = `NOP;
                endcase
            end
            `I_type: begin
                o_rd_wr     = 1'b1;
                o_imm       = signed'(i_inst[31:20]);
                o_ALUsrc1   = 1'b1;
                o_ALUsrc2   = 1'b0;
                o_DM_OE     = 1'b0;
                o_store     = 1'b0;
                o_b_inst    = 1'b0;
                o_jal       = 1'b0;
                o_jalr      = 1'b0;
                unique case (funct3)
                    3'b000: o_mnemonic = `ADDI;
                    3'b010: o_mnemonic = `SLTI;
                    3'b011: o_mnemonic = `SLTIU;
                    3'b100: o_mnemonic = `XORI;
                    3'b110: o_mnemonic = `ORI;
                    3'b111: o_mnemonic = `ANDI;
                    3'b001: o_mnemonic = `SLLI;
                    3'b101: o_mnemonic = i_inst[30] ? `SRAI : `SRLI; 
                    default:o_mnemonic = `NOP;
                endcase
            end
            `L_type: begin
                o_rd_wr     = 1'b1;
                o_imm       = signed'(i_inst[31:20]);
                o_ALUsrc1   = 1'b1;
                o_ALUsrc2   = 1'b0;
                o_DM_OE     = 1'b1;
                o_store     = 1'b0;
                o_b_inst    = 1'b0;
                o_jal       = 1'b0;
                o_jalr      = 1'b0;
                unique case (funct3)
                    3'b000: o_mnemonic = `LB;
                    3'b001: o_mnemonic = `LH;
                    3'b010: o_mnemonic = `LW;
                    3'b100: o_mnemonic = `LBU;
                    3'b101: o_mnemonic = `LHU;
                    default:o_mnemonic = `NOP;
                endcase
            end
            `S_type: begin
                o_rd_wr     = 1'b0;
                o_imm       = signed'({i_inst[31:25], i_inst[11:7]});
                o_ALUsrc1   = 1'b1;
                o_ALUsrc2   = 1'b0;
                o_DM_OE     = 1'b0;
                o_store     = 1'b1;
                o_b_inst    = 1'b0;
                o_jal       = 1'b0;
                o_jalr      = 1'b0;
                unique case (funct3)
                    3'b000: o_mnemonic = `SB;
                    3'b001: o_mnemonic = `SH;
                    3'b010: o_mnemonic = `SW;
                    default:o_mnemonic = `NOP;
                endcase
            end
            `LUI_type: begin
                o_rd_wr     = 1'b1;
                o_imm       = {i_inst[31:12], 12'b0};
                o_mnemonic  = `LUI;
                o_ALUsrc1   = 1'b0;
                o_ALUsrc2   = 1'b0;
                o_DM_OE     = 1'b0;
                o_store     = 1'b0;
                o_b_inst    = 1'b0;
                o_jal       = 1'b0;
                o_jalr      = 1'b0;
            end
            `AUIPC_type: begin
                o_rd_wr     = 1'b1;
                o_imm       = {i_inst[31:12], 12'b0};
                o_mnemonic  = `AUIPC;
                o_ALUsrc1   = 1'b0;
                o_ALUsrc2   = 1'b0;
                o_DM_OE     = 1'b0;
                o_store     = 1'b0;
                o_b_inst    = 1'b0;
                o_jal       = 1'b0;
                o_jalr      = 1'b0;
            end
            `JAL_type: begin
                o_rd_wr     = 1'b1;
                o_imm       = signed'({i_inst[31], i_inst[19:12], i_inst[20], i_inst[30:21], 1'b0});
                o_mnemonic  = `JAL;
                o_ALUsrc1   = 1'b0;
                o_ALUsrc2   = 1'b0;
                o_DM_OE     = 1'b0;
                o_store     = 1'b0;
                o_b_inst    = 1'b0;
                o_jal       = 1'b1;
                o_jalr      = 1'b0;
            end
            `JALR_type: begin
                o_rd_wr     = 1'b1;
                o_imm       = signed'({i_inst[31:20]});
                o_mnemonic  = `JALR;
                o_ALUsrc1   = 1'b0;
                o_ALUsrc2   = 1'b0;
                o_DM_OE     = 1'b0;
                o_store     = 1'b0;
                o_b_inst    = 1'b0;
                o_jal       = 1'b0;
                o_jalr      = 1'b1;
            end
            `B_type: begin
                o_rd_wr     = 1'b0;
                o_imm       = signed'({i_inst[31], i_inst[7], i_inst[30:25], i_inst[11:8], 1'b0});
                o_ALUsrc1   = 1'b1;
                o_ALUsrc2   = 1'b1;
                o_DM_OE     = 1'b0;
                o_store     = 1'b0;
                o_b_inst    = 1'b1;
                o_jal       = 1'b0;
                o_jalr      = 1'b0;
                unique case (funct3)
                    3'b000: o_mnemonic = `BEQ;
                    3'b001: o_mnemonic = `BNE;
                    3'b100: o_mnemonic = `BLT;
                    3'b101: o_mnemonic = `BGE;
                    3'b110: o_mnemonic = `BLTU;
                    3'b111: o_mnemonic = `BGEU;
                    default:o_mnemonic = `NOP;
                endcase
            end
            default: begin
                o_mnemonic  = `NOP;
                o_rd_wr     = 1'b0;
                o_imm       = 32'b0;
                o_ALUsrc1   = 1'b0;
                o_ALUsrc2   = 1'b0;
                o_DM_OE     = 1'b0;
                o_store     = 1'b0;
                o_b_inst    = 1'b0;
                o_jal       = 1'b0;
                o_jalr      = 1'b0;
            end
        endcase
    end
endmodule