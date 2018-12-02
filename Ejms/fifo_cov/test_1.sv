program testcase(intf_cnt intf);
  environment env = new(intf);
         
  initial
    begin
    //env.coverage.cov.sample();
    env.drvr.reset();
    env.drvr.write(10);
    end
endprogram
