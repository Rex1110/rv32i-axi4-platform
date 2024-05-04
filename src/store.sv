module store(
    input                   i_store,
    input           [ 2:0]  i_funct3,
    input           [31:0]  i_ALUout,
    input           [31:0]  i_rs2_data,

    output  logic           o_DM_CS,
    output  logic   [ 3:0]  o_DM_WEB,
    output  logic   [31:0]  o_DM_addr,
    output  logic   [31:0]  o_DM_DI
);

    localparam SW = 3'b010;
    localparam SB = 3'b000;
    localparam SH = 3'b001;

    
    always_comb begin
        if (i_store) begin
            unique case (i_funct3) 
                SW: begin
                    o_DM_CS     = 1'b1;
                    o_DM_DI     = i_rs2_data;
                    o_DM_WEB    = 4'b0000;
                end
                SB: begin
                    o_DM_CS     = 1'b1;
                    o_DM_DI     = {4{i_rs2_data[7:0]}};
                    unique case (i_ALUout[1:0])
                        2'b00: o_DM_WEB = 4'b1110;
                        2'b01: o_DM_WEB = 4'b1101;
                        2'b10: o_DM_WEB = 4'b1011;
                        2'b11: o_DM_WEB = 4'b0111;
                    endcase
                end
                SH: begin
                    o_DM_CS     = 1'b1;
                    o_DM_DI     = {2{i_rs2_data[15:0]}};
                    o_DM_WEB    = i_ALUout[1] ? 4'b0011 : 4'b1100;
                end
                default: begin
                    o_DM_CS     = 1'b0;
                    o_DM_DI     = 32'b0;
                    o_DM_WEB    = 4'b1111;
                end
            endcase
        end else begin
            o_DM_CS     = 1'b0;
            o_DM_DI     = 32'b0;
            o_DM_WEB    = 4'b1111;
        end
    end

    assign o_DM_addr = i_ALUout;
endmodule