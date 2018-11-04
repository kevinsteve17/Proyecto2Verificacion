class sdrcMon;
    sdrcSB sb;
    
    function new(sdrcSB sb);
        $display("Creating SDRC Monitor");
        this.sb = sb;
        // TO DO implementation

    endfunction

    task reset(port_list);
        // TO DO implementation
    endtask

    task BurstWrite(arguments);
        // TO DO implementation
    endtask //
    
endclass