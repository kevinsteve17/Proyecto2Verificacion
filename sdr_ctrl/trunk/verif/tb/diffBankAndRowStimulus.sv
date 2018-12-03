class diffBankAndRowStimulus;

  function new();
        $display("Creating address with diff bank and row stimulus");
  endfunction

  // random data types/signals
  randc logic [11:0] row;
  rand  logic [1:0]  bank;

endclass
