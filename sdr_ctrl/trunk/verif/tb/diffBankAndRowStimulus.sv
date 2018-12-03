class diffBankAndRowStimulus;

  function new();
        $display("Creating address with diff bank and row stimulus");
  endfunction

  // non random signals
  logic  [7:0] burst_size;

  // random data types/signals
  randc logic [11:0] row;
  rand  logic [1:0]  bank;

  //assignations
  task generateAddress();
    begin
      burst_size = this.bank + 8'h4;
    end
  endtask

endclass
