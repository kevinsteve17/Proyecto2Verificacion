class sdrcDrv;
    sdrcSB _sb;

    function new(sdrcSB sb);
        $display("Creating SDRC Driver");
        this._sb = sb;
    endfunction

endclass