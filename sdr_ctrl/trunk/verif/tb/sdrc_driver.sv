class sdrcDrv;
    sdrcSB sb;

    function new(sdrcSB sb);
        $display("Creating SDRC Driver");
        this.sb = sb;
    endfunction

    task reset(arguments);
        
    endtask //

    task BurstWrite(port_list);
        pass
    endtask

endclass