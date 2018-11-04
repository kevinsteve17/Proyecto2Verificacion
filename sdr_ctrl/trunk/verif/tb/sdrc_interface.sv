interface inft_sdrcntrl #(parameter sdr_data_width = 16,
                          parameter sdr_byte_width = 2,
                          parameter dw = 32,
                          parameter app_addr_w = 26);

    logic sdram_clk;
    logic sdram_resetn;
    logic sys_clk;

    intf_sdram sdram_intf () #(.sdr_data_width(sdr_data_width), .sdr_byte_width(sdr_byte_width));
    intf_WishBone wb_intf #(.dw(dw), .app_addr_w(app_addr_w)) intf_WishBone();

endinterface                          
