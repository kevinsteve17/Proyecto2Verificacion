interface intf_sdram #(parameter sdr_data_width = 16,
                       parameter sdr_byte_width = 2);

    logic [sdr_byte_width-1:0]  sdr_dqm;
    logic [1:0]                 sdr_ba;
    logic [12:0]                sdr_addr;
    logic [sdr_data_width-1:0]  sdr_dq;
    logic sdr_clke;
    logic sdr_ras_n;    
    logic sdr_cas_n;
    logic sdr_we_n;
    logic sdr_cs_n;

endinterface