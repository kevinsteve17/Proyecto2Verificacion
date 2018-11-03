interface intf_cnt(input clk);

  wire rst;
  wire wr_cs;
  wire rd_cs;
  wire [7:0] data_in;
  wire rd_en;
  wire wr_en;
  wire [7:0] data_out;
  wire empty;
  wire full; 

endinterface
