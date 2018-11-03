class sdrcMon;
    sdrcSB _sb;
    
    function new(sdrcSB sb);
        $display("Creating SDRC Monitor");
        this._sb = sb;
        // TO DO implementation

    endfunction

    task reset(port_list);
        // TO DO implementation
    endtask

    task BurstWrite(arguments);
        // TO DO implementation
    endtask //
BurstWrite/