`timescale 1ns/1ps

interface intf_wishBone #(parameter dw = 32,
                          parameter APP_AW = 26);

    logic wb_rst_i;
    logic wb_clk_i;
    logic wb_stb_i;
    logic wb_ack_o;
    logic [APP_AW-1:0] wb_addr_i;
    logic wb_we_i;
    logic [dw-1:0]   wb_dat_i;
    logic [dw/8-1:0] wb_sel_i;
    logic [dw-1:0]  wb_dat_o;
    logic wb_cyc_i;
    logic [2:0] wb_cti_i;

endinterface
