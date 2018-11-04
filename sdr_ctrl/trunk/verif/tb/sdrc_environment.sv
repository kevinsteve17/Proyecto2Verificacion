class sdrcEnv;
    sdrcSB sb;
    sdrcMon mon;
    sdrcDrv drv;
    virtual inft_sdrcntrl inft;

    function new (virtual inft_sdrcntrl inft);
      $display("Creating SDRC Environment");
      this.inft = inft;
      sb = new();
      drv = new (inft, sb);
      mon = new (inft, sb);


    endfunction
endclass
