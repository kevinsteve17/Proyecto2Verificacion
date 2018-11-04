class sdrcMon;
    sdrcSB sb;
    virtual inft_sdrcntrl inft;
    
    function new(virtual inft_sdrcntrl inft,sdrcSB sb);
        $display("Creating SDRC Monitor");
        this.sb = sb;
        this.inft = inft; 
        // TO DO implementation

    endfunction

    task reset(port_list);
        // TO DO implementation
        this.inft.sdram_intf.sdr_cs_n = 1;

    endtask

    task BurstWrite(arguments);
        // TO DO implementation
    endtask //

endclass
