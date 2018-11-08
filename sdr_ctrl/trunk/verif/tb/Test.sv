program testcase(inft_sdrcntrl intf);

  sdrcEnv env = new(intf);
         
  initial
    begin
    $display("-------------------------------------- ");
    $display(" Case-1: Single Write/Read Case        ");
    $display("-------------------------------------- ");
 
    env.drv.reset();
    
    // single write and single read
    env.drv.BurstWrite(32'h4_0000,8'h4);
    #1000;
    env.mon.BurstRead();
    
    $display("-------------------------------------- ");
    $display(" End-1: Single Write/Read Case        ");
    $display("-------------------------------------- ");

    end
endprogram
