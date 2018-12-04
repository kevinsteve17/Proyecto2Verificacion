class diffBankAndRowStimulus;
  function new();
        $display("Creating address with diff bank and row stimulus");
  endfunction

  // non random signals
  logic  [7:0] burst_size;
  logic  [11:0] row;
  logic  [1:0]  bank;  

  // random data types/signals
  randc logic [11:0] rnd_row;
  rand  logic [1:0]  rnd_bank;

  //assignations
  task generateAddress(input int row_arg  = -1, int bank_arg = -1);
    begin
      this.row  = rnd_row;
      this.bank = rnd_bank;

      if (row_arg != -1 &&) begin
        this.row  = row_arg;
      end

      if (bank_arg == -1) begin
        this.bank = bank_arg;
      end

      burst_size = this.bank + 8'h4;
    end
  endtask

endclass
