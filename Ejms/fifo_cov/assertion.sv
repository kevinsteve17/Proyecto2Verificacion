`define DUV_PATH top.dut

module whitebox();

  //Inmediate assertion
  always_comb begin
    full_empty_0: assert (`DUV_PATH.empty ^ `DUV_PATH.full);
  end
  
  //Defered assertion
  always_comb begin
  //  full_empty_1: assert #0 (`DUV_PATH.empty ^ `DUV_PATH.full);
  end

  property full_empty_p_0;
    @(posedge `DUV_PATH.clk)
    disable iff (!`DUV_PATH.rst)
    (`DUV_PATH.empty ^ `DUV_PATH.full) == 1;
  endproperty

  property full_empty_p_1;
    @(posedge `DUV_PATH.clk)
    $isunknown(`DUV_PATH.empty) == 0 |->
    $isunknown(`DUV_PATH.full) == 0 |->
    (`DUV_PATH.empty ^ `DUV_PATH.full) == 1;
  endproperty

  full_empty_2: assert property (full_empty_p_0) else $warning ("Rule1.1 full xor empty signals violated");

  full_empty_3: assert property (full_empty_p_1) else $warning ("Rule1.2 full xor empty signals violated");

  full_empty_4: assert property ( @(posedge `DUV_PATH.clk) (`DUV_PATH.empty ^ `DUV_PATH.full) == 1) else $warning ("full xor empty signals violated");

  full_empty_clean_up: assert property ( @(posedge `DUV_PATH.clk) $rose(`DUV_PATH.rst) |-> (`DUV_PATH.empty == 1 && `DUV_PATH.full == 0))  else $warning ("full xor empty signals violated");
  
endmodule
