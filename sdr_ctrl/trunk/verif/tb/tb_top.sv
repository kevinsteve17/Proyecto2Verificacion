//`timescale 1ns/1ps

    module top();

    parameter P_SYS  = 10;     //    200MHz
    parameter P_SDR  = 20;     //    100MHz

    // General
    reg  RESETN;
    reg  sys_clk;
    //reg  sdram_clk;

    initial sys_clk = 0;
    //initial sdram_clk = 0;

    always #(P_SYS/2) sys_clk = !sys_clk;
    //always #(P_SDR/2) sdram_clk = !sdram_clk;

    parameter SDR_DW = 16;
    parameter SDR_BW = 2;
    parameter dw = 32;
    parameter APP_AW = 26;

    // Interface instance
    inft_sdrcntrl #(.SDR_DW(SDR_DW), .SDR_BW(SDR_BW), .dw(dw), .APP_AW(APP_AW)) sdrc_intf(
        RESETN,
        sys_clk
    );

    /*sdrc_top #(.SDR_DW(SDR_DW), .SDR_BW(SDR_BW)) duv(
        // system
        .cfg_sdr_width  (2'b00),    // TODO: 2'b00 just for 32 BIT case
        .cfg_colbits    (2'b00),    // double check, org top mentioned only 8bit case
        
        // wish bone
        .wb_rst_i       (!sdrc_intf.restn), 
        .wb_clk_i       (sdrc_intf.sys_clk),
        .wb_stb_i       (sdrc_intf.wb_intf.wb_stb_i),
        .wb_ack_o       (sdrc_intf.wb_intf.wb_ack_o),
        .wb_addr_i      (sdrc_intf.wb_intf.wb_addr_i),
        .wb_we_i        (sdrc_intf.wb_intf.wb_we_i),
        .wb_dat_i       (sdrc_intf.wb_intf.wb_dat_i),
        .wb_sel_i       (sdrc_intf.wb_intf.wb_sel_i),
        .wb_dat_o       (sdrc_intf.wb_intf.wb_dat_o),
        .wb_cyc_i       (sdrc_intf.wb_intf.wb_cyc_i),
        .wb_cti_i       (sdrc_intf.wb_intf.wb_cti_i)       
    );*/

endmodule
