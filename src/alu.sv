`include "../include/define.svh"
module alu(
    input           [ 5:0]  i_mnemonic,
    input           [31:0]  i_src1,
    input           [31:0]  i_src2,

    output  logic   [31:0]  o_ALUout
);
    always_comb begin
        unique case (i_mnemonic)
            `ADD, `ADDI: begin
                o_ALUout = i_src1 + i_src2;
            end
            `SUB: begin
                o_ALUout = i_src1 - i_src2;
            end
            `SLL, `SLLI: begin
                o_ALUout = i_src1 << i_src2[4:0];
            end
            `SLT, `SLTI: begin
                o_ALUout = ($signed(i_src1) < $signed(i_src2)) ? 32'b1 : 32'b0;
            end
            `SLTU, `SLTIU: begin
                o_ALUout = ($unsigned(i_src1) < $unsigned(i_src2)) ? 32'b1 : 32'b0;
            end
            `XOR, `XORI: begin
                o_ALUout = i_src1 ^ i_src2;
            end
            `SRL, `SRLI: begin
                o_ALUout = i_src1 >> i_src2[4:0];
            end
            `SRA, `SRAI: begin
                o_ALUout = $signed(i_src1) >>> i_src2[4:0];
            end
            `OR, `ORI: begin
                o_ALUout = i_src1 | i_src2;
            end
            `AND, `ANDI: begin
                o_ALUout = i_src1 & i_src2;
            end
            `JALR: begin
                o_ALUout = i_src1 + 32'd4;
            end
            `JAL: begin
                o_ALUout = i_src1 + 32'd4;
            end
            `LB, `LH, `LW, `LHU, `LBU: begin
                o_ALUout = i_src1 + i_src2;
            end
            `SB, `SH, `SW: begin
                o_ALUout = i_src1 + i_src2;
            end
            `AUIPC: begin
                o_ALUout = i_src1 + i_src2;
            end
            `LUI: begin
                o_ALUout = i_src2;
            end
            default: begin
                o_ALUout = 32'b0;
            end
        endcase
    end
endmodule