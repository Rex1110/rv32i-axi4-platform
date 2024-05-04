`include "cpu.sv"
module CPU_wrapper(
    input   ACLK,
    input   ARESETn,
    // Write
    output  logic   [`AXI_ID_BITS-1:0   ]   AWID_M1,
    output  logic   [`AXI_ADDR_BITS-1:0 ]   AWADDR_M1,
    output  logic   [`AXI_LEN_BITS-1:0  ]   AWLEN_M1,
    output  logic   [`AXI_SIZE_BITS-1:0 ]   AWSIZE_M1,
    output  logic   [1:0                ]   AWBURST_M1,
    output  logic                           AWVALID_M1,
    input                                   AWREADY_M1,

    output  logic   [`AXI_DATA_BITS-1:0 ]   WDATA_M1,
    output  logic   [`AXI_STRB_BITS-1:0 ]   WSTRB_M1,
    output  logic                           WLAST_M1,
    output  logic                           WVALID_M1,
    input                                   WREADY_M1,

    input           [`AXI_ID_BITS-1:0   ]   BID_M1,
    input           [1:0                ]   BRESP_M1,
    input                                   BVALID_M1,
    output  logic                           BREADY_M1,

    // Read
    output  logic   [`AXI_ID_BITS-1:0   ]   ARID_M0,
    output  logic   [`AXI_ADDR_BITS-1:0 ]   ARADDR_M0,
    output  logic   [`AXI_LEN_BITS-1:0  ]   ARLEN_M0,
    output  logic   [`AXI_SIZE_BITS-1:0 ]   ARSIZE_M0,
    output  logic   [1:0                ]   ARBURST_M0,
    output  logic                           ARVALID_M0,
    input                                   ARREADY_M0,

    input           [`AXI_ID_BITS-1:0   ]   RID_M0,
    input           [`AXI_DATA_BITS-1:0 ]   RDATA_M0,
    input           [1:0                ]   RRESP_M0,
    input                                   RLAST_M0,
    input                                   RVALID_M0,
    output  logic                           RREADY_M0,

    output  logic   [`AXI_ID_BITS-1:0   ]   ARID_M1,
    output  logic   [`AXI_ADDR_BITS-1:0 ]   ARADDR_M1,
    output  logic   [`AXI_LEN_BITS-1:0  ]   ARLEN_M1,
    output  logic   [`AXI_SIZE_BITS-1:0 ]   ARSIZE_M1,
    output  logic   [1:0                ]   ARBURST_M1,
    output  logic                           ARVALID_M1,
    input                                   ARREADY_M1,

    input           [`AXI_ID_BITS-1:0   ]   RID_M1,
    input           [`AXI_DATA_BITS-1:0 ]   RDATA_M1,
    input           [1:0                ]   RRESP_M1,
    input                                   RLAST_M1,
    input                                   RVALID_M1,
    output  logic                           RREADY_M1
);
    logic   [31:0]  o_IM_addr, o_DM_addr, o_DM_DI;
    logic   [3:0]   o_DM_WEB;
    logic   o_DM_CS, o_DM_OE;
    logic   LS_stall, mem_stall;
    logic   branch, branch_reg;

    cpu cpu0(
        .clk            (ACLK       ),
        .rst            (~ARESETn   ),

        .i_IM_inst      (RDATA_M0   ),
        .i_DM_DI        (RDATA_M1   ),

        .o_IM_addr      (o_IM_addr  ),
        .o_DM_CS        (o_DM_CS    ),
        .o_DM_WEB       (o_DM_WEB   ),
        .o_DM_addr      (o_DM_addr  ),
        .o_DM_DI        (o_DM_DI    ),
        .o_DM_OE        (o_DM_OE    ),

        .i_rvalid_rready(RREADY_M0 && RVALID_M0 && ~branch_reg),
        .mem_stall      (mem_stall  ),

        .o_branch       (branch     ),
        .o_LS_stall     (LS_stall   )
    );

    // used to M0 read inst invalid beacuse branch
    always_ff @(posedge ACLK, negedge ARESETn) begin
        if (~ARESETn) begin
            branch_reg <= 'd0;
        end else if (branch) begin
            branch_reg <= 'd1;
        end else if ((RREADY_M0 && RVALID_M0)) begin
            branch_reg <= 'd0;
        end else begin
            branch_reg <= branch_reg;
        end
    end


    logic [3:0] m0_state, m0_next_state;
    logic [3:0] m1_state, m1_next_state;

    always_ff @(posedge ACLK, negedge ARESETn) begin
        if (~ARESETn) begin
            m0_state <= 4'd0;
        end else begin
            m0_state <= m0_next_state;
        end
    end
    
    always_ff @(posedge ACLK, negedge ARESETn) begin
        if (~ARESETn) begin
            ARADDR_M0  <= 'd0;
        end else if (m0_state == 4'd0) begin
            ARADDR_M0  <= o_IM_addr;
        end else begin
            ARADDR_M0  <= ARADDR_M0;
        end
    end

    assign ARID_M0    = `AXI_ID_BITS'd0;
    assign ARLEN_M0   = `AXI_LEN_BITS'd0;       // support burst length 0 + 1
    assign ARSIZE_M0  = `AXI_SIZE_BITS'b010;    // byte in transfer 4 * 8 bits
    assign ARBURST_M0 = 2'b01;                  // support INCR burst type
    assign RREADY_M0  = (m0_state == 4'd2);
    assign ARVALID_M0 = (m0_state == 4'd1);

    always_comb begin
        unique case (m0_state)
            4'd0: begin // IDLE if not ls
                m0_next_state = LS_stall ? 4'd0 : 4'd1;
            end
            4'd1: begin // AR
                m0_next_state = (ARVALID_M0 && ARREADY_M0) ? 4'd2 : 4'd1;
            end
            4'd2: begin // R
                m0_next_state = (RVALID_M0 && RREADY_M0 && RLAST_M0) ? 4'd0 : 4'd2;
            end
            default: begin
                m0_next_state = 4'd0;
            end
        endcase
    end

    always_ff @(posedge ACLK, negedge ARESETn) begin
        if (~ARESETn) begin
            m1_state <= 4'd0;
        end else begin
            m1_state <= m1_next_state;
        end
    end

    
    always_ff @(posedge ACLK, negedge ARESETn) begin
        if (~ARESETn) begin
            AWADDR_M1 <= 'd0;
            WDATA_M1  <= 'd0;
            WSTRB_M1  <= 'd0;
            ARADDR_M1 <= 'd0;
        end else if (m1_state == 4'd0) begin
            AWADDR_M1 <= o_DM_addr;
            WDATA_M1  <= o_DM_DI;
            WSTRB_M1  <= o_DM_WEB;
            ARADDR_M1 <= o_DM_addr;
        end else begin
            AWADDR_M1 <= AWADDR_M1;
            WDATA_M1  <= WDATA_M1 ;
            WSTRB_M1  <= WSTRB_M1 ;
            ARADDR_M1 <= o_DM_addr;
        end
    end


    assign ARID_M1      = `AXI_ID_BITS'd1;
    assign ARLEN_M1     = `AXI_LEN_BITS'd0;     // support burst length 0 + 1
    assign ARSIZE_M1    = `AXI_SIZE_BITS'b010;  // byte in transfer 4 * 8 bits
    assign ARBURST_M1   = 2'b01;                // support INCR burst type
    assign RREADY_M1    = (m1_state == 4'd5);
    assign ARVALID_M1   = (m1_state == 4'd4);
    
    assign AWID_M1      = `AXI_ID_BITS'b0001;
    assign AWLEN_M1     = `AXI_LEN_BITS'd0;     // support burst length 0 + 1
    assign AWSIZE_M1    = `AXI_SIZE_BITS'b010;  // byte in transfer 4 * 8 bits
    assign AWBURST_M1   = 2'b01;                // support INCR burst type
    assign AWVALID_M1   = (m1_state == 4'd1);

    assign WLAST_M1     = (m1_state == 4'd2);
    assign WVALID_M1    = (m1_state == 4'd2);
    assign BREADY_M1    = (m1_state == 4'd3);

    always_comb begin
        unique case (m1_state) 
            4'd0: begin //IDLE
                if (o_DM_WEB != 4'b1111) begin
                    m1_next_state = 4'd1;
                end else if (o_DM_OE) begin
                    m1_next_state = 4'd4;
                end else begin
                    m1_next_state = 4'd0;
                end
            end
            4'd1: begin // WA
                m1_next_state = (AWVALID_M1 && AWREADY_M1) ? 4'd2 : 4'd1;
            end
            4'd2: begin // W
                m1_next_state = (WVALID_M1 && WREADY_M1 && WLAST_M1) ? 4'd3 : 4'd2;
            end
            4'd3: begin // B
                m1_next_state = (BVALID_M1 && BREADY_M1) ? 4'd0: 4'd3;
            end
            4'd4: begin // AR
                m1_next_state = (ARVALID_M1 && ARREADY_M1) ? 4'd5 : 4'd4;
            end
            4'd5: begin // R
                m1_next_state = (RVALID_M1 && RREADY_M1 && RLAST_M1) ? 4'd0 : 4'd5;
            end
            default: begin
                m1_next_state = 4'd0;
            end
        endcase
    end

    // wait for resp
    assign mem_stall = (m1_next_state != 4'd0);

endmodule