module bju(
    input                   i_b_inst,
    input           [ 2:0]  i_funct3,
    input                   i_jal,
    input                   i_jalr,
    input           [31:0]  i_src1,
    input           [31:0]  i_src2,
    input           [31:0]  i_fw_rs1_data,
    input           [31:0]  i_imm,
    input           [31:0]  i_pc,

    output  logic           o_branch,
    output  logic   [31:0]  o_branch_addr

);

    localparam BEQ = 3'b000;
    localparam BNE = 3'b001;
    localparam BLT = 3'b100;
    localparam BGE = 3'b101;
    localparam BLTU = 3'b110;
    localparam BGEU = 3'b111;

    always_comb begin
        if (i_jal) begin
            o_branch = 1'b1;
            o_branch_addr = i_pc + i_imm;
        end else if (i_jalr) begin
            o_branch = 1'b1;
            o_branch_addr = i_imm + i_fw_rs1_data;
        end else begin
            if (i_b_inst) begin
                unique case (i_funct3)
                    BEQ: begin
                        o_branch = (i_src1 == i_src2) ? 1'b1 : 1'b0;
                        o_branch_addr = i_pc + i_imm;
                    end
                    BNE: begin
                        o_branch = (i_src1 != i_src2) ? 1'b1 : 1'b0;
                        o_branch_addr = i_pc + i_imm;
                    end
                    BLT: begin
                        o_branch = ($signed(i_src1) < $signed(i_src2)) ? 1'b1 : 1'b0;
                        o_branch_addr = i_pc + i_imm;
                    end
                    BGE: begin
                        o_branch = ($signed(i_src1) >= $signed(i_src2)) ? 1'b1: 1'b0;
                        o_branch_addr = i_pc + i_imm;
                    end
                    BLTU: begin
                        o_branch = ($unsigned(i_src1) < $unsigned(i_src2)) ? 1'b1 : 1'b0;
                        o_branch_addr = i_pc + i_imm;
                    end
                    BGEU: begin
                        o_branch = ($unsigned(i_src1) >= $unsigned(i_src2)) ? 1'b1 : 1'b0;
                        o_branch_addr = i_pc + i_imm;
                    end
                    default: begin
                        o_branch = 1'b0;
                        o_branch_addr = 32'b0;
                    end
                endcase
            end else begin
                o_branch = 1'b0;
                o_branch_addr = 32'b0;
            end
        end
    end

endmodule