`timescale 1ns/1ps

// top module
module top();

`ifdef SDR_32BIT
    parameter SDR_DW = 32;
    parameter SDR_BW = 4;
    parameter CNFG_SDR_WDITH = 2'b00;
 `elsif SDR_16BIT    
    parameter SDR_DW = 16;
    parameter SDR_BW = 2;
    parameter CNFG_SDR_WDITH = 2'b01;
 `elsif SDR_8BIT
    parameter SDR_DW = 8;
    parameter SDR_BW = 1;
    parameter CNFG_SDR_WDITH = 2'b10;
`endif

`ifdef 8_BIT_COL
    parameter CNFG_COL_BITS = 2'b00;
 `elsif 9_BIT_COL    
    parameter CNFG_COL_BITS = 2'b01;;
 `elsif 10_BIT_COL
    parameter CNFG_COL_BITS = 2'b10;
 `elsif 11_BIT_COL
    parameter CNFG_COL_BITS = 2'b11;
`endif

    parameter APP_AW = 26;

    // General
    logic  sys_clk;
    logic  sdram_clk;

    // clocks 
    Clks clks(
        .sys_clk(sys_clk),
        .sdram_clk(sdram_clk)
    );

    // Interface instance
    inft_sdrcntrl #(.SDR_DW(SDR_DW), .SDR_BW(SDR_BW), .APP_AW(APP_AW), .CNFG_COL_BITS(CNFG_COL_BITS)) sdrc_intf(
        sys_clk,
        sdram_clk
    );

    // Whitebox interface instance
    intf_whitebox whitebox_intf(sdrc_intf.sdram_clk);

    // assertion
    whitebox assertion(whitebox_intf); 

    sdrc_top #(.SDR_DW(SDR_DW), .SDR_BW(SDR_BW)) duv(
        // system
        .cfg_sdr_width      (CNFG_SDR_WDITH),
        .cfg_colbits        (2'b01),   
        
        // wish bone
        .wb_rst_i           (!sdrc_intf.resetn), 
        .wb_clk_i           (sdrc_intf.sys_clk),
        .wb_stb_i           (sdrc_intf.wb_intf.wb_stb_i),
        .wb_ack_o           (sdrc_intf.wb_intf.wb_ack_o),
        .wb_addr_i          (sdrc_intf.wb_intf.wb_addr_i),
        .wb_we_i            (sdrc_intf.wb_intf.wb_we_i),
        .wb_dat_i           (sdrc_intf.wb_intf.wb_dat_i),
        .wb_sel_i           (sdrc_intf.wb_intf.wb_sel_i),
        .wb_dat_o           (sdrc_intf.wb_intf.wb_dat_o),
        .wb_cyc_i           (sdrc_intf.wb_intf.wb_cyc_i),
        .wb_cti_i           (sdrc_intf.wb_intf.wb_cti_i),

        // SDRAM
        .sdram_clk          (sdrc_intf.sdram_clk),
        .sdram_resetn       (sdrc_intf.resetn),
        .sdr_cs_n           (sdrc_intf.sdram_intf.sdr_cs_n),
        .sdr_cke            (sdrc_intf.sdram_intf.sdr_cke),
        .sdr_ras_n          (sdrc_intf.sdram_intf.sdr_ras_n),
        .sdr_cas_n          (sdrc_intf.sdram_intf.sdr_cas_n),
        .sdr_we_n           (sdrc_intf.sdram_intf.sdr_we_n),
        .sdr_dqm            (sdrc_intf.sdram_intf.sdr_dqm),
        .sdr_ba             (sdrc_intf.sdram_intf.sdr_ba),
        .sdr_addr           (sdrc_intf.sdram_intf.sdr_addr), 
        .sdr_dq             (sdrc_intf.sdram_intf.sdr_dq),

        // Parameters */
        .sdr_init_done      (sdrc_intf.sdram_intf.sdr_init_done),
        .cfg_req_depth      (2'h3),  //how many req. buffer should hold
        .cfg_sdr_en         (1'b1),
        .cfg_sdr_mode_reg   (sdrc_intf.sdram_intf.cfg_sdr_mode_reg),   //(13'h033),
        .cfg_sdr_tras_d     (4'h4),
        .cfg_sdr_trp_d      (4'h2),
        .cfg_sdr_trcd_d     (4'h2),
        .cfg_sdr_cas        (3'h3),
        .cfg_sdr_trcar_d    (4'h7),
        .cfg_sdr_twr_d      (4'h1),
        .cfg_sdr_rfsh       (12'h100), // reduced from 12'hC35
        .cfg_sdr_rfmax      (3'h6)
    );

    // to fix the sdram interface timing issue
    wire #(2.0) sdram_clk_d   = sdram_clk;

`ifdef SDR_32BIT
    mt48lc2m32b2 #(.data_bits(32)) u_sdram32 (
          .Dq                 (sdrc_intf.sdram_intf.sdr_dq) , 
          .Addr               (sdrc_intf.sdram_intf.sdr_addr[10:0]     ), 
          .Ba                 (sdrc_intf.sdram_intf.sdr_ba             ), 
          .Clk                (sdram_clk_d        ), 
          .Cke                (sdrc_intf.sdram_intf.sdr_cke            ), 
          .Cs_n               (sdrc_intf.sdram_intf.sdr_cs_n           ), 
          .Ras_n              (sdrc_intf.sdram_intf.sdr_ras_n          ), 
          .Cas_n              (sdrc_intf.sdram_intf.sdr_cas_n          ), 
          .We_n               (sdrc_intf.sdram_intf.sdr_we_n           ), 
          .Dqm                (sdrc_intf.sdram_intf.sdr_dqm            )
     );
`elsif SDR_16BIT
   IS42VM16400K u_sdram16 (
          .dq                 (sdrc_intf.sdram_intf.sdr_dq), 
          .addr               (sdrc_intf.sdram_intf.sdr_addr[11:0]), 
          .ba                 (sdrc_intf.sdram_intf.sdr_ba), 
          .clk                (sdram_clk_d        ), 
          .cke                (sdrc_intf.sdram_intf.sdr_cke), 
          .csb                (sdrc_intf.sdram_intf.sdr_cs_n), 
          .rasb               (sdrc_intf.sdram_intf.sdr_ras_n), 
          .casb               (sdrc_intf.sdram_intf.sdr_cas_n), 
          .web                (sdrc_intf.sdram_intf.sdr_we_n), 
          .dqm                (sdrc_intf.sdram_intf.sdr_dqm)
    );
`elsif SDR_8BIT
    mt48lc8m8a2 #(.data_bits(8)) u_sdram8 (
          .Dq                 (sdrc_intf.sdram_intf.sdr_dq) , 
          .Addr               (sdrc_intf.sdram_intf.sdr_addr[10:0]), 
          .Ba                 (sdrc_intf.sdram_intf.sdr_ba), 
          .Clk                (sdram_clk_d), 
          .Cke                (sdrc_intf.sdram_intf.sdr_cke), 
          .Cs_n               (sdrc_intf.sdram_intf.sdr_cs_n), 
          .Ras_n              (sdrc_intf.sdram_intf.sdr_ras_n), 
          .Cas_n              (sdrc_intf.sdram_intf.sdr_cas_n), 
          .We_n               (sdrc_intf.sdram_intf.sdr_we_n), 
          .Dqm                (sdrc_intf.sdram_intf.sdr_dqm)
     );
`endif 

    /////////////////////////////////////////////////////////////////////////
    // Run Test Cases
    /////////////////////////////////////////////////////////////////////////

    testcase2 test2(sdrc_intf);
    

endmodule
