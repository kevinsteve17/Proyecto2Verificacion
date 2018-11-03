class driver;
  stimulus sti;
  scoreboard sb;
 
  virtual intf_cnt intf;
        
  function new(virtual intf_cnt intf,scoreboard sb);
    this.intf = intf;
    this.sb = sb;
  endfunction
        
  task reset();  // Reset method
    intf.data_in = 0;
    intf.rst = 0;
    intf.wr_cs = 0;
    intf.rd_cs = 0;
    intf.data_in = 0;
    intf.rd_en = 0;
    intf.wr_en = 0;
    intf.rst = 0;
    @ (negedge intf.clk);
    intf.rst = 1;
    @ (negedge intf.clk);
    intf.wr_cs = 1;
    intf.rd_cs = 1;

  endtask
        
  task write(input integer iteration);
    repeat(iteration)
    begin
      sti = new();
      @ (negedge intf.clk);
      if(sti.randomize()) // Generate stimulus
        intf.data_in = sti.value; // Drive to DUT
      intf.wr_en = 1;
      sb.store.push_front(sti.value);// Cal exp value and store in Scoreboard
    end
    @ (negedge intf.clk);
    intf.wr_en = 0;
  endtask
endclass
