class monitor;
  scoreboard sb;
  virtual intf_cnt intf;

  logic [7:0] sb_value;
          
  function new(virtual intf_cnt intf,scoreboard sb);
    this.intf = intf;
    this.sb = sb;
  endfunction
          
  task check();
    forever
    @ (negedge intf.rd_en)
    sb_value = sb.store.pop_back();
    if( sb_value != intf.data_out) // Get expected value from scoreboard and compare with DUT output
      $display(" * ERROR * DUT count is %b :: SB count is %b ", intf.data_out,sb_value );
    else
      $display("           DUT count is %b :: SB count is %b ", intf.data_out,sb_value );
  endtask
endclass
