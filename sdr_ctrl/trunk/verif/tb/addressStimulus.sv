class addrStimulus;

  randc logic [31:0] address;
  rand logic  [7:0]  burst_size;

  constraint addr_range  { address    inside {[0:16777215]}; } 
  constraint burst_range { burst_size inside {[0:15]}; } 

endclass
