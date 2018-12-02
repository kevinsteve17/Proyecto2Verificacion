class environment;
  driver drvr;
  scoreboard sb;
  monitor mntr;
  funct_coverage coverage;
  
  virtual intf_cnt intf;
           
  function new(virtual intf_cnt intf);
    $display("Creating environment");
    this.intf = intf;
    sb = new();
    drvr = new(intf,sb);
    mntr = new(intf,sb);
    coverage = new(intf);
    fork 
      mntr.check();
    join_none
  endfunction
           
endclass
