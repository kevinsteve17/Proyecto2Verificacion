class sdrcDrv;
    sdrcSB sb;
    virtual inft_sdrcntrl inft;

    function new(virtual inft_sdrcntrl inft,sdrcSB sb);
        $display("Creating SDRC Driver");
        this.sb = sb;
        this.inft = inft;

    endfunction

    task reset(arguments);
        
    endtask //

    task BurstWrite(port_list);
        //pass
    endtask

endclass
