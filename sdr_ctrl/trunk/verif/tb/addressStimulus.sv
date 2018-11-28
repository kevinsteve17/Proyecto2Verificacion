class addrStimulus;

  rand logic [31:0] address;
  rand logic [7:0] burst_size;

  constraint addr_range { address inside {[0:16777215]}; } 

endclass
