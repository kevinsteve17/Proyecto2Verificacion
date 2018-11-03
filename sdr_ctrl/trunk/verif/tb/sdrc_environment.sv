class sdrcEnv;
    sdrcSB sb;
    sdrcMon mon;
    sdrcDrv drv;
    

    function new (args);
      $$display("Creating SDRC Environment");
      sb = new();
      drv = new (sb);
      mon = new (sb);


    endfunction
endclass