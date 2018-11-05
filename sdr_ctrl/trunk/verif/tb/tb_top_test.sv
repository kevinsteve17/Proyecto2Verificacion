`timescale 1ns/1ps

// Helper methods to configure DUV BW configuration
class DuvConfigurationUtils;

    function bit[1:0] getSdrWidth(int dw);
        if (dw == 32) begin
            return 2'b00;
        end
        else if (dw == 16) begin
            return 2'b01;
        end if (dw == 8) begin
            return 2'b10;
        end
        return 2'b01;

    endfunction
endclass

// top module
module top();

    DuvConfigurationUtils duvConfigUtils = new();

    parameter P_SYS  = 10;     //    200MHz
    parameter P_SDR  = 20;     //    100MHz

    // General
    reg  RESETN;
    reg  sys_clk;
    reg  sdram_clk;

    initial sys_clk = 0;
    initial sdram_clk = 0;

    always #(P_SYS/2) sys_clk = !sys_clk;
    always #(P_SDR/2) sdram_clk = !sdram_clk;

    parameter SDR_DW = 16;
    parameter SDR_BW = 2;
    //parameter dw = 32;
    parameter APP_AW = 26;

    // Interface instance
    inft_sdrcntrl #(.SDR_DW(SDR_DW), .SDR_BW(SDR_BW), .dw(SDR_DW), .APP_AW(APP_AW)) sdrc_intf(
        sys_clk,
        sdram_clk
    );

    sdrc_top #(.SDR_DW(SDR_DW), .SDR_BW(SDR_BW)) duv(
        // system
        .cfg_sdr_width      (duvConfigUtils.getSdrWidth(SDR_DW)),
        .cfg_colbits        (2'b00),    // double check, org top mentioned only 8bit case
        
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
        .cfg_sdr_mode_reg   (13'h033),
        .cfg_sdr_tras_d     (4'h4),
        .cfg_sdr_trp_d      (4'h2),
        .cfg_sdr_trcd_d     (4'h2),
        .cfg_sdr_cas        (3'h3),
        .cfg_sdr_trcar_d    (4'h7),
        .cfg_sdr_twr_d      (4'h1),
        .cfg_sdr_rfsh       (12'h100), // reduced from 12'hC35
        .cfg_sdr_rfmax      (3'h6)
    );

    ///////////////////////// TEST /////////////////////////////
    
    // to fix the sdram interface timing issue
    wire #(2.0) sdram_clk_d   = sdrc_intf.sdram_clk;

    IS42VM16400K u_sdram16 (
          .dq                 (sdrc_intf.sdram_intf.sdr_dq), 
          .addr               (sdrc_intf.sdram_intf.sdr_addr[11:0]), 
          .ba                 (sdrc_intf.sdram_intf.sdr_ba), 
          .clk                (sdram_clk_d), 
          .cke                (sdrc_intf.sdram_intf.sdr_cke), 
          .rasb               (sdrc_intf.sdram_intf.sdr_ras_n), 
          .casb               (sdrc_intf.sdram_intf.sdr_cas_n), 
          .web                (sdrc_intf.sdram_intf.sdr_we_n), 
          .dqm                (sdrc_intf.sdram_intf.sdr_dqm)
    );

    //--------------------
    // data/address/burst length FIFO
    //--------------------
    int dfifo[$]; // data fifo
    int afifo[$]; // address  fifo
    int bfifo[$]; // Burst Length fifo

    reg [31:0] read_data;
    reg [31:0] ErrCnt;
    int k;
    reg [31:0] StartAddr;
    /////////////////////////////////////////////////////////////////////////
    // Test Case
    /////////////////////////////////////////////////////////////////////////

    initial begin //{
    ErrCnt          = 0;
    sdrc_intf.wb_intf.wb_addr_i      = 0;
    sdrc_intf.wb_intf.wb_dat_i      = 0;
    sdrc_intf.wb_intf.wb_sel_i       = 4'h0;
    sdrc_intf.wb_intf.wb_we_i        = 0;
    sdrc_intf.wb_intf.wb_stb_i       = 0;
    sdrc_intf.wb_intf.wb_cyc_i       = 0;

    sdrc_intf.resetn    = 1'h1;

    #100
    // Applying reset
    sdrc_intf.resetn    = 1'h0;
    #10000;
    // Releasing reset
    sdrc_intf.resetn    = 1'h1;
    #1000;
    wait(u_dut.sdr_init_done == 1);

    #1000;
    $display("-------------------------------------- ");
    $display(" Case-1: Single Write/Read Case        ");
    $display("-------------------------------------- ");

    burst_write(32'h4_0000,8'h4);  
    #1000;
    burst_read();  

    // Repeat one more time to analysis the 
    // SDRAM state change for same col/row address
    $display("-------------------------------------- ");
    $display(" Case-2: Repeat same transfer once again ");
    $display("----------------------------------------");
    burst_write(32'h4_0000,8'h4);  
    burst_read();  
    burst_write(32'h0040_0000,8'h5);  
    burst_read();  
    $display("----------------------------------------");
    $display(" Case-3 Create a Page Cross Over        ");
    $display("----------------------------------------");
    burst_write(32'h0000_0FF0,8'h8);  
    burst_write(32'h0001_0FF4,8'hF);  
    burst_write(32'h0002_0FF8,8'hF);  
    burst_write(32'h0003_0FFC,8'hF);  
    burst_write(32'h0004_0FE0,8'hF);  
    burst_write(32'h0005_0FE4,8'hF);  
    burst_write(32'h0006_0FE8,8'hF);  
    burst_write(32'h0007_0FEC,8'hF);  
    burst_write(32'h0008_0FD0,8'hF);  
    burst_write(32'h0009_0FD4,8'hF);  
    burst_write(32'h000A_0FD8,8'hF);  
    burst_write(32'h000B_0FDC,8'hF);  
    burst_write(32'h000C_0FC0,8'hF);  
    burst_write(32'h000D_0FC4,8'hF);  
    burst_write(32'h000E_0FC8,8'hF);  
    burst_write(32'h000F_0FCC,8'hF);  
    burst_write(32'h0010_0FB0,8'hF);  
    burst_write(32'h0011_0FB4,8'hF);  
    burst_write(32'h0012_0FB8,8'hF);  
    burst_write(32'h0013_0FBC,8'hF);  
    burst_write(32'h0014_0FA0,8'hF);  
    burst_write(32'h0015_0FA4,8'hF);  
    burst_write(32'h0016_0FA8,8'hF);  
    burst_write(32'h0017_0FAC,8'hF);  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  

    $display("----------------------------------------");
    $display(" Case:4 4 Write & 4 Read                ");
    $display("----------------------------------------");
    burst_write(32'h4_0000,8'h4);  
    burst_write(32'h5_0000,8'h5);  
    burst_write(32'h6_0000,8'h6);  
    burst_write(32'h7_0000,8'h7);  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  

    $display("---------------------------------------");
    $display(" Case:5 24 Write & 24 Read With Different Bank and Row ");
    $display("---------------------------------------");
    //----------------------------------------
    // Address Decodeing:
    //  with cfg_col bit configured as: 00
    //    <12 Bit Row> <2 Bit Bank> <8 Bit Column> <2'b00>
    //
    burst_write({12'h000,2'b00,8'h00,2'b00},8'h4);   // Row: 0 Bank : 0
    burst_write({12'h000,2'b01,8'h00,2'b00},8'h5);   // Row: 0 Bank : 1
    burst_write({12'h000,2'b10,8'h00,2'b00},8'h6);   // Row: 0 Bank : 2
    burst_write({12'h000,2'b11,8'h00,2'b00},8'h7);   // Row: 0 Bank : 3
    burst_write({12'h001,2'b00,8'h00,2'b00},8'h4);   // Row: 1 Bank : 0
    burst_write({12'h001,2'b01,8'h00,2'b00},8'h5);   // Row: 1 Bank : 1
    burst_write({12'h001,2'b10,8'h00,2'b00},8'h6);   // Row: 1 Bank : 2
    burst_write({12'h001,2'b11,8'h00,2'b00},8'h7);   // Row: 1 Bank : 3
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  

    burst_write({12'h002,2'b00,8'h00,2'b00},8'h4);   // Row: 2 Bank : 0
    burst_write({12'h002,2'b01,8'h00,2'b00},8'h5);   // Row: 2 Bank : 1
    burst_write({12'h002,2'b10,8'h00,2'b00},8'h6);   // Row: 2 Bank : 2
    burst_write({12'h002,2'b11,8'h00,2'b00},8'h7);   // Row: 2 Bank : 3
    burst_write({12'h003,2'b00,8'h00,2'b00},8'h4);   // Row: 3 Bank : 0
    burst_write({12'h003,2'b01,8'h00,2'b00},8'h5);   // Row: 3 Bank : 1
    burst_write({12'h003,2'b10,8'h00,2'b00},8'h6);   // Row: 3 Bank : 2
    burst_write({12'h003,2'b11,8'h00,2'b00},8'h7);   // Row: 3 Bank : 3

    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  

    burst_write({12'h002,2'b00,8'h00,2'b00},8'h4);   // Row: 2 Bank : 0
    burst_write({12'h002,2'b01,8'h01,2'b00},8'h5);   // Row: 2 Bank : 1
    burst_write({12'h002,2'b10,8'h02,2'b00},8'h6);   // Row: 2 Bank : 2
    burst_write({12'h002,2'b11,8'h03,2'b00},8'h7);   // Row: 2 Bank : 3
    burst_write({12'h003,2'b00,8'h04,2'b00},8'h4);   // Row: 3 Bank : 0
    burst_write({12'h003,2'b01,8'h05,2'b00},8'h5);   // Row: 3 Bank : 1
    burst_write({12'h003,2'b10,8'h06,2'b00},8'h6);   // Row: 3 Bank : 2
    burst_write({12'h003,2'b11,8'h07,2'b00},8'h7);   // Row: 3 Bank : 3

    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    burst_read();  
    $display("---------------------------------------------------");
    $display(" Case: 6 Random 2 write and 2 read random");
    $display("---------------------------------------------------");
    for(k=0; k < 20; k++) begin
        StartAddr = $random & 32'h003FFFFF;
        burst_write(StartAddr,($random & 8'h0f)+1);  
    #100;

        StartAddr = $random & 32'h003FFFFF;
        burst_write(StartAddr,($random & 8'h0f)+1);  
    #100;
        burst_read();  
    #100;
        burst_read();  
    #100;
    end

    #10000;

            $display("###############################");
        if(ErrCnt == 0)
            $display("STATUS: SDRAM Write/Read TEST PASSED");
        else
            $display("ERROR:  SDRAM Write/Read TEST FAILED");
            $display("###############################");

        $finish;
    end

    task burst_write;
    input [31:0] Address;
    input [7:0]  bl;
    int i;
    begin
    afifo.push_back(Address);
    bfifo.push_back(bl);

    @ (negedge sys_clk);
    $display("Write Address: %x, Burst Size: %d",Address,bl);

    for(i=0; i < bl; i++) begin
        sdrc_intf.wb_intf.wb_stb_i        = 1;
        sdrc_intf.wb_intf.wb_cyc_i        = 1;
        sdrc_intf.wb_intf.wb_we_i         = 1;
        sdrc_intf.wb_intf.wb_sel_i        = 4'b1111;
        sdrc_intf.wb_intf.wb_addr_i       = Address[31:2]+i;
        sdrc_intf.wb_intf.wb_dat_i        = $random & 32'hFFFFFFFF;
        dfifo.push_back(sdrc_intf.wb_intf.wb_dat_i);

        do begin
            @ (posedge sys_clk);
        end while(sdrc_intf.wb_intf.wb_ack_o == 1'b0);
            @ (negedge sys_clk);
    
        $display("Status: Burst-No: %d  Write Address: %x  WriteData: %x ",i,sdrc_intf.wb_intf.wb_addr_i, sdrc_intf.wb_intf.wb_dat_i);
    end
    sdrc_intf.wb_intf.wb_stb_i        = 0;
    sdrc_intf.wb_intf.wb_cyc_i        = 0;
    sdrc_intf.wb_intf.wb_we_i         = 'hx;
    sdrc_intf.wb_intf.wb_sel_i        = 'hx;
    sdrc_intf.wb_intf.wb_addr_i       = 'hx;
    sdrc_intf.wb_intf.wb_dat_i        = 'hx;
    end
    endtask

    task burst_read;
    reg [31:0] Address;
    reg [7:0]  bl;

    int i,j;
    reg [31:0]   exp_data;
    begin
    
    Address = afifo.pop_front(); 
    bl      = bfifo.pop_front(); 
    @ (negedge sys_clk);

        for(j=0; j < bl; j++) begin
            sdrc_intf.wb_intf.wb_stb_i        = 1;
            sdrc_intf.wb_intf.wb_cyc_i        = 1;
            sdrc_intf.wb_intf.wb_we_i         = 0;
            sdrc_intf.wb_intf.wb_addr_i       = Address[31:2]+j;

            exp_data        = dfifo.pop_front(); // Exptected Read Data
            do begin
                @ (posedge sys_clk);
            end while(sdrc_intf.wb_intf.wb_ack_o == 1'b0);
            if(sdrc_intf.wb_intf.wb_dat_o !== exp_data) begin
                $display("READ ERROR: Burst-No: %d Addr: %x Rxp: %x Exd: %x",j, sdrc_intf.wb_intf.wb_addr_i, sdrc_intf.wb_intf.wb_dat_o,exp_data);
                ErrCnt = ErrCnt+1;
            end else begin
                $display("READ STATUS: Burst-No: %d Addr: %x Rxd: %x",j, sdrc_intf.wb_intf.wb_addr_i, sdrc_intf.wb_intf.wb_dat_o);
            end 
            @ (negedge sdram_clk);
        end
    sdrc_intf.wb_intf.wb_stb_i        = 0;
    sdrc_intf.wb_intf.wb_cyc_i        = 0;
    sdrc_intf.wb_intf.wb_we_i         = 'hx;
    sdrc_intf.wb_intf.wb_addr_i       = 'hx;
    end
    endtask

endmodule