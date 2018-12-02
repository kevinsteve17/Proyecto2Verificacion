class funct_coverage;

  virtual intf_cnt intf;
  
  covergroup cov0 @(intf.clk);
    Feature_empty: coverpoint intf.empty;
    Feature_full: coverpoint intf.full;
    Feature_data: coverpoint intf.data_in {option.auto_bin_max=8;}
    Feature_empty_seq: coverpoint intf.empty {bins seq = (0=>1=>0);}
    Feature_full_seq: coverpoint intf.full {bins seq = (0=>1=>0);}
  endgroup

  covergroup cov1 @(intf.clk);
    empty_repeat: coverpoint intf.empty {

      bins empty_5times = (1[*5]);
      
      }

    full_repeat: coverpoint intf.full {

      bins full_5times = (1[*5]);
      
      }
    cross empty_repeat, full_repeat;
  endgroup
  
  
  function new(virtual intf_cnt intf);
    this.intf =intf;
    cov0 =new();
    cov1 =new();
  endfunction


endclass
