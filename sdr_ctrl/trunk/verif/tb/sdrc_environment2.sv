class sdrcEnv2 extends sdrcEnv;
    sdrcSB2 sb;
    sdrcMon2 mon;
    sdrcDrv2 drv;
    //virtual inft_sdrcntrl inft;

    function new (virtual inft_sdrcntrl inft);
      super.new(inft);
      $display("Creating SDRC Environment");
      
      sb = new();
      drv = new (inft, sb);
      mon = new (inft, sb);

    endfunction
endclass
