program testcase(inft_sdrcntrl intf);

  // sdrcEnv env = new(intf); // Deprecated for second project.
  sdrcEnv2 env = new(intf);
  int k;
  reg [31:0] StartAddr;
  
  initial 
  begin
    // set test execution count
    env.mon.testCasesCount = 4;
    env.mon.execTestCasesCount = env.mon.testCasesCount;

    // reset
    env.drv.reset();
    
    // Tests to execute
    tc1_single_read();
    tc2_x2_read();
    tc3_page_cross_over();
    tc5_x24_Write_and_Read_diff_row_bank();
    //tc4_x4_Write_4Read();
    //tc6_x2_rndm_Write_and_Read();

    // check test exec. results
    env.mon.Check();
  end
     
  task tc1_single_read();
    begin
      $display("-------------------------------------- ");
      $display(" Case-1: Single Write/Read Case        ");
      $display("-------------------------------------- ");
  
      env.drv.BurstWrite_rnd_addr();
      #1000;
      env.mon.BurstRead();

      env.mon.execTestCasesCount = env.mon.execTestCasesCount -1;
      
      $display("-------------------------------------- ");
      $display(" End-1: Single Write/Read Case        ");
      $display("-------------------------------------- ");
    end
  endtask

  // Test case 2 Single Write/Read Case
  task tc2_x2_read();
    begin
      $display("-------------------------------------- ");
      $display(" Case-2: x2 Write/Read Case        ");
      $display("-------------------------------------- ");
  
      // single write and single read
      env.drv.BurstWrite_rnd_addr();
      env.mon.BurstRead();

      env.drv.BurstWrite_rnd_addr();
      env.mon.BurstRead();
      
      env.mon.execTestCasesCount = env.mon.execTestCasesCount -1;

      $display("-------------------------------------- ");
      $display(" End-2: x2 Write/Read Case        ");
      $display("-------------------------------------- ");
    end
  endtask

  // Case:3 Create a Page Cross Over
  task tc3_page_cross_over();
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
      
      env.mon.execTestCasesCount = env.mon.execTestCasesCount -1;
      
      $display("-------------------------------------- ");
      $display(" End-3 Create a Page Cross Over");
      $display("-------------------------------------- ");
    end
  endtask


  // Case:4 4 Write & 4 Read
  task tc4_x4_Write_4Read();
    begin
      $display("----------------------------------------");
      $display(" Case:4 x4 Write & Read                ");
      $display("----------------------------------------");
      
      env.drv.BurstWrite_rnd_addr();  
      env.drv.BurstWrite_rnd_addr();  
      env.drv.BurstWrite_rnd_addr();  
      env.drv.BurstWrite_rnd_addr();  
      env.mon.BurstRead();  
      env.mon.BurstRead();  
      env.mon.BurstRead();  
      env.mon.BurstRead();
      
      env.mon.execTestCasesCount = env.mon.execTestCasesCount -1;

      $display("-------------------------------------- ");
      $display(" End-4 x4 Write &  Read");
      $display("-------------------------------------- ");  
    end
  endtask

  // Case:5 24 Write & 24 Read With Different Bank and Row
  task tc5_x24_Write_and_Read_diff_row_bank();
    begin
      $display("---------------------------------------");
      $display(" Case:5 24 Write & 24 Read With Different Bank and Row ");
      $display("---------------------------------------");

      env.drv.BurstWrite_diff_row_bank();
      env.drv.BurstWrite_diff_row_bank();
      env.drv.BurstWrite_diff_row_bank();

      env.mon.BurstRead();  
      env.mon.BurstRead();  
      env.mon.BurstRead();

      env.mon.execTestCasesCount = env.mon.execTestCasesCount -1;

      $display("-------------------------------------- ");
      $display(" End-5 24 Write & 24 Read With Different Bank and Row");
      $display("-------------------------------------- ");              
    end
  endtask

  // Case: 6 Random 2 write and 2 read random
  task tc6_x2_rndm_Write_and_Read();
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

        env.mon.execTestCasesCount = env.mon.execTestCasesCount -1;

      $display("-------------------------------------- ");
      $display(" End- 6 Random 2 write and 2 read random");
      $display("-------------------------------------- ");        
    end
  endtask    

endprogram
