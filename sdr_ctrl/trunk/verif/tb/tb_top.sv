`timescale 1ns/1ps

module top();

    parameter SDR_DW = 16;
    parameter SDR_BW = 2;
    parameter dw = 32;
    parameter APP_AW = 26;

    // Interface instance
    inft_sdrcntrl #(.SDR_DW(SDR_DW), .SDR_BW(SDR_BW), .dw(dw), .APP_AW(APP_AW)) sdrc_intf();

    //sdrc_top #(.SDR_DW(SDR_DW), .SDR_BW(SDR_BW)) duv(

    //);

endmodule