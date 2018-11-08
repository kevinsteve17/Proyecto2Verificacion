program testcase(inft_sdrcntrl intf);

  sdrcEnv env = new(intf);
  int k;
  reg [31:0] StartAddr;
  
  initial 
  begin
    env.drv.reset();
    tc1_single_read();
    tc2_single_read();
    tc3_single_read();
    tc4_4Write_4Read();
    tc5_24Write_24Read();
    tc4_6rndm_Write_2rndm_Read();

  end
     
    task tc1_single_read();
      begin
        $display("-------------------------------------- ");
        $display(" Case-1: Single Write/Read Case        ");
        $display("-------------------------------------- ");
    
        
        
        // single write and single read
        env.drv.BurstWrite(32'h4_0000,8'h4);
        #1000;
        env.mon.BurstRead();
        
        $display("-------------------------------------- ");
        $display(" End-1: Single Write/Read Case        ");
        $display("-------------------------------------- ");
      end
    endtask

    task tc2_single_read();
      begin
        $display("-------------------------------------- ");
        $display(" Case-1: Single Write/Read Case        ");
        $display("-------------------------------------- ");
    
        // single write and single read
        env.drv.BurstWrite(32'h4_0000,8'h4);
        env.mon.BurstRead();

        env.drv.BurstWrite(32'h0040_0000,8'h5);
        env.mon.BurstRead();
        
        $display("-------------------------------------- ");
        $display(" End-1: Single Write/Read Case        ");
        $display("-------------------------------------- ");
      end
    endtask

    task tc3_single_read();
      begin
       
        $display("----------------------------------------");
        $display(" Case-3 Create a Page Cross Over        ");
        $display("----------------------------------------");
        env.drv.BurstWrite(32'h0000_0FF0,8'h8);  
        env.drv.BurstWrite(32'h0001_0FF4,8'hF);  
        env.drv.BurstWrite(32'h0002_0FF8,8'hF);  
        env.drv.BurstWrite(32'h0003_0FFC,8'hF);  
        env.drv.BurstWrite(32'h0004_0FE0,8'hF);  
        env.drv.BurstWrite(32'h0005_0FE4,8'hF);  
        env.drv.BurstWrite(32'h0006_0FE8,8'hF);  
        env.drv.BurstWrite(32'h0007_0FEC,8'hF);  
        env.drv.BurstWrite(32'h0008_0FD0,8'hF);  
        env.drv.BurstWrite(32'h0009_0FD4,8'hF);  
        env.drv.BurstWrite(32'h000A_0FD8,8'hF);  
        env.drv.BurstWrite(32'h000B_0FDC,8'hF);  
        env.drv.BurstWrite(32'h000C_0FC0,8'hF);  
        env.drv.BurstWrite(32'h000D_0FC4,8'hF);  
        env.drv.BurstWrite(32'h000E_0FC8,8'hF);  
        env.drv.BurstWrite(32'h000F_0FCC,8'hF);  
        env.drv.BurstWrite(32'h0010_0FB0,8'hF);  
        env.drv.BurstWrite(32'h0011_0FB4,8'hF);  
        env.drv.BurstWrite(32'h0012_0FB8,8'hF);  
        env.drv.BurstWrite(32'h0013_0FBC,8'hF);  
        env.drv.BurstWrite(32'h0014_0FA0,8'hF);  
        env.drv.BurstWrite(32'h0015_0FA4,8'hF);  
        env.drv.BurstWrite(32'h0016_0FA8,8'hF);  
        env.drv.BurstWrite(32'h0017_0FAC,8'hF);  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();
        $display("-------------------------------------- ");
        $display(" End-1: Single Write/Read Case        ");
        $display("-------------------------------------- ");
      end
    endtask


    // Case:4 4 Write & 4 Read
    task tc4_4Write_4Read();
      begin
        $display("----------------------------------------");
        $display(" Case:4 4 Write & 4 Read                ");
        $display("----------------------------------------");
        env.drv.BurstWrite(32'h4_0000,8'h4);  
        env.drv.BurstWrite(32'h5_0000,8'h5);  
        env.drv.BurstWrite(32'h6_0000,8'h6);  
        env.drv.BurstWrite(32'h7_0000,8'h7);  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
      end
    endtask

    // Case:5 24 Write & 24 Read With Different Bank and Row
    task tc5_24Write_24Read();
      begin
        $display("---------------------------------------");
        $display(" Case:5 24 Write & 24 Read With Different Bank and Row ");
        $display("---------------------------------------");
        env.drv.BurstWrite({12'h000,2'b00,8'h00,2'b00},8'h4);   // Row: 0 Bank : 0
        env.drv.BurstWrite({12'h000,2'b01,8'h00,2'b00},8'h5);   // Row: 0 Bank : 1
        env.drv.BurstWrite({12'h000,2'b10,8'h00,2'b00},8'h6);   // Row: 0 Bank : 2
        env.drv.BurstWrite({12'h000,2'b11,8'h00,2'b00},8'h7);   // Row: 0 Bank : 3
        env.drv.BurstWrite({12'h001,2'b00,8'h00,2'b00},8'h4);   // Row: 1 Bank : 0
        env.drv.BurstWrite({12'h001,2'b01,8'h00,2'b00},8'h5);   // Row: 1 Bank : 1
        env.drv.BurstWrite({12'h001,2'b10,8'h00,2'b00},8'h6);   // Row: 1 Bank : 2
        env.drv.BurstWrite({12'h001,2'b11,8'h00,2'b00},8'h7);   // Row: 1 Bank : 3
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  

        env.drv.BurstWrite({12'h002,2'b00,8'h00,2'b00},8'h4);   // Row: 2 Bank : 0
        env.drv.BurstWrite({12'h002,2'b01,8'h00,2'b00},8'h5);   // Row: 2 Bank : 1
        env.drv.BurstWrite({12'h002,2'b10,8'h00,2'b00},8'h6);   // Row: 2 Bank : 2
        env.drv.BurstWrite({12'h002,2'b11,8'h00,2'b00},8'h7);   // Row: 2 Bank : 3
        env.drv.BurstWrite({12'h003,2'b00,8'h00,2'b00},8'h4);   // Row: 3 Bank : 0
        env.drv.BurstWrite({12'h003,2'b01,8'h00,2'b00},8'h5);   // Row: 3 Bank : 1
        env.drv.BurstWrite({12'h003,2'b10,8'h00,2'b00},8'h6);   // Row: 3 Bank : 2
        env.drv.BurstWrite({12'h003,2'b11,8'h00,2'b00},8'h7);   // Row: 3 Bank : 3

        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  

        env.drv.BurstWrite({12'h002,2'b00,8'h00,2'b00},8'h4);   // Row: 2 Bank : 0
        env.drv.BurstWrite({12'h002,2'b01,8'h01,2'b00},8'h5);   // Row: 2 Bank : 1
        env.drv.BurstWrite({12'h002,2'b10,8'h02,2'b00},8'h6);   // Row: 2 Bank : 2
        env.drv.BurstWrite({12'h002,2'b11,8'h03,2'b00},8'h7);   // Row: 2 Bank : 3
        env.drv.BurstWrite({12'h003,2'b00,8'h04,2'b00},8'h4);   // Row: 3 Bank : 0
        env.drv.BurstWrite({12'h003,2'b01,8'h05,2'b00},8'h5);   // Row: 3 Bank : 1
        env.drv.BurstWrite({12'h003,2'b10,8'h06,2'b00},8'h6);   // Row: 3 Bank : 2
        env.drv.BurstWrite({12'h003,2'b11,8'h07,2'b00},8'h7);   // Row: 3 Bank : 3

        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();  
        env.mon.BurstRead();
      end
    endtask

    // Case: 6 Random 2 write and 2 read random
    task tc4_6rndm_Write_2rndm_Read();
      begin
        $display("---------------------------------------------------");
        $display(" Case: 6 Random 2 write and 2 read random");
        $display("---------------------------------------------------");
        for(k=0; k < 20; k++) begin
            StartAddr = $random & 32'h003FFFFF;
            env.drv.BurstWrite(StartAddr,($random & 8'h0f)+1);  
            #100;
            StartAddr = $random & 32'h003FFFFF;
            env.drv.BurstWrite(StartAddr,($random & 8'h0f)+1);  
            #100;
            env.mon.BurstRead();  
            #100;
            env.mon.BurstRead();  
            #100;
          end 
      end
    endtask    

endprogram
