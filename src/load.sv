module load(
    input           [ 2:0]  i_funct3,
    input           [31:0]  i_ALUout,
    input           [31:0]  i_DM_DI,

    output  logic   [31:0]  o_DM_data
);

    localparam LB = 3'b000;
    localparam LH = 3'b001;
    localparam LW = 3'b010;
    localparam LHU= 3'b101;
    localparam LBU= 3'b100;

    always_comb begin
        unique case (i_funct3)
            LW: o_DM_data   = i_DM_DI;
            LH: o_DM_data   = i_ALUout[1] ? signed'(i_DM_DI[31:16]) : signed'(i_DM_DI[15:0]);
            LB:
                unique case (i_ALUout[1:0])
                    2'b00: o_DM_data = signed'(i_DM_DI[ 7: 0]);
                    2'b01: o_DM_data = signed'(i_DM_DI[15: 8]);
                    2'b10: o_DM_data = signed'(i_DM_DI[23:16]);
                    2'b11: o_DM_data = signed'(i_DM_DI[31:24]);
                endcase
            LHU: o_DM_data = i_ALUout[1] ? i_DM_DI[31:16] : i_DM_DI[15:0];
            LBU:
                unique case (i_ALUout[1:0])
                    2'b00: o_DM_data = i_DM_DI[ 7: 0];
                    2'b01: o_DM_data = i_DM_DI[15: 8];
                    2'b10: o_DM_data = i_DM_DI[23:16];
                    2'b11: o_DM_data = i_DM_DI[31:24];
                endcase
            default: begin
                o_DM_data = 'd0;
            end
        endcase
    end
endmodule