`timescale 1ns/1ps
`define DUV_PATH top.duv

interface intf_whitebox (sdram_clk);
    input sdram_clk;
    
    logic sdr_ras_n;    
    logic sdr_cas_n;
    logic sdr_we_n;

    assign sdr_ras_n = `DUV_PATH.sdr_ras_n;
    assign sdr_cas_n = `DUV_PATH.sdr_cas_n;
    assign sdr_we_n = `DUV_PATH.sdr_we_n;
    
    /*logic [SDR_BW-1:0]  sdr_dqm;
    logic [1:0]         sdr_ba;
    logic [12:0]        sdr_addr;
    wire [SDR_DW-1:0]   sdr_dq;
    logic sdr_cke;
    logic sdr_cs_n;
    //logic sdram_clk;
    logic sdram_resetn;
    logic sdr_init_done;*/

endinterface
