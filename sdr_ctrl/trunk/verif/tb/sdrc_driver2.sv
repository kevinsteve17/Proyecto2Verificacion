class sdrcDrv2;
    sdrcSB2 sb;
    virtual inft_sdrcntrl inft;

    // Stimulus objects
    diffBankAndRowStimulus diff_bank_row_stim   = new();
    addrStimulus rnd_addr_stim                  = new();
    pageCrossOverStimulus rand_pco_stim         = new();

    function new(virtual inft_sdrcntrl inft, sdrcSB2 sb);
        $display("Creating SDRC Driver");
        this.sb = sb;
        this.inft = inft;

    endfunction

    task reset();
        begin
            sb.ErrCnt                             = 0;
            this.inft.wb_intf.wb_addr_i           = 0;
            this.inft.wb_intf.wb_dat_i            = 0;
            this.inft.wb_intf.wb_sel_i            = 4'h0;
            this.inft.wb_intf.wb_we_i             = 0;
            this.inft.wb_intf.wb_stb_i            = 0;
            this.inft.wb_intf.wb_cyc_i            = 0;
            this.inft.resetn                      = 1'h1;

            #100
            // Applying reset
            this.inft.resetn    = 1'h0;
           
            #10000;
            // Releasing reset
            this.inft.resetn    = 1'h1;
            
            #1000;
            wait(this.inft.sdram_intf.sdr_init_done == 1);
        end 
    endtask

    task ModifyModeRegister(input int registerValue);
        begin
	    this.inft.sdram_intf.cfg_sdr_mode_reg = registerValue;
        end 
    endtask



    task BurstWrite();
        // input [31:0] Address;  // Deprecated for second project
        // input [7:0]  bl;       // Deprecated for second project
        input int unsigned Address;  
        input int unsigned bl; 
        int i;
        begin
            // sb.dir.push_back(Address); // Deprecated for second project
            sb.burstLenght.push_back(bl);
            
            @ (negedge this.inft.sys_clk);
            $display("Write Address: %x, Burst Size: %d",Address,bl);
            for(i=0; i < bl; i++) begin
                this.inft.wb_intf.wb_stb_i        = 1;
                this.inft.wb_intf.wb_cyc_i        = 1;
                this.inft.wb_intf.wb_we_i         = 1;
                this.inft.wb_intf.wb_sel_i        = 4'b1111;
                this.inft.wb_intf.wb_addr_i       = Address[31:2]+i;
                this.inft.wb_intf.wb_dat_i        = $random & 32'hFFFFFFFF;
                // sb.store.push_back(this.inft.wb_intf.wb_dat_i); // Deprecated for second project
                sb.dir.push_back(this.inft.wb_intf.wb_addr_i);
                sb.store[this.inft.wb_intf.wb_addr_i] = this.inft.wb_intf.wb_dat_i;

                do begin
                    @ (posedge this.inft.sys_clk);
                end while(this.inft.wb_intf.wb_ack_o == 1'b0);
                    @ (negedge this.inft.sys_clk);
            
                $display("Status: Burst-No: %d  Write Address: %x  WriteData: %x ",i,this.inft.wb_intf.wb_addr_i,this.inft.wb_intf.wb_dat_i);
            end
            this.inft.wb_intf.wb_stb_i        = 0;
            this.inft.wb_intf.wb_cyc_i        = 0;
            this.inft.wb_intf.wb_we_i         = 'hx;
            this.inft.wb_intf.wb_sel_i        = 'hx;
            this.inft.wb_intf.wb_addr_i       = 'hx;
            this.inft.wb_intf.wb_dat_i        = 'hx;       
        end
        
    endtask

    // Write to address with Different Bank and Row
    task BurstWrite_diff_row_bank(input int row_arg  = -1, input int bank_arg = -1);
        logic [11:0] row;
        logic [1:0]  bank;

        begin
            if(diff_bank_row_stim.randomize())
            begin
                diff_bank_row_stim.generateAddress();
                bank = diff_bank_row_stim.bank;
                row  = diff_bank_row_stim.row;
            end

            if (row_arg != -1) begin
                row  = row_arg;
            end

            if (bank_arg != -1) begin
                bank = bank_arg;
            end

            this.BurstWrite({row, bank, 8'h00,2'b00},           // address
                            diff_bank_row_stim.burst_size);     // burst size
        end
    endtask

    // Write to rndm address
    task BurstWrite_rnd_addr();
        begin
            if(rnd_addr_stim.randomize())
            begin
                this.BurstWrite(rnd_addr_stim.address,          // address
                                rnd_addr_stim.burst_size);      // burst size
            end
        end
    endtask

    // Page cross over 
    task BurstWrite_page_cross_over();
        begin
            if(rand_pco_stim.randomize())
            begin
		        rand_pco_stim.generatePageCrossOverAddress();
                this.BurstWrite({rand_pco_stim.row, rand_pco_stim.bank, rand_pco_stim.column, 2'b00},   // address
                                rand_pco_stim.burst_size);                                              // burst size
            end
        end
    endtask

    // Write to address with Different Bank and Row
    task BurstWrite_diff_col_row_bank(input int row_arg  = -1, input int bank_arg = -1, input int col_arg = -1);
        logic [11:0] row;
        logic [1:0]  bank;
        logic [7+this.inft.CNFG_COL_BITS : 0]  column;
        
        begin
            if(diff_bank_row_stim.randomize())
            begin
                diff_bank_row_stim.generateAddress();
                bank   = diff_bank_row_stim.bank;
                row    = diff_bank_row_stim.row;
                //column = diff_bank_row_stim.column;
            end

            if (row_arg != -1) begin
                row  = row_arg;
            end

            if (bank_arg != -1) begin
                bank = bank_arg;
            end

            if (col_arg != -1) begin
                column = col_arg;
            end            

	    $display("############# BurstWrite_diff_col_row_bank, COL:%d", column);
            this.BurstWrite({row, bank, column, 2'b00},           // address
                            diff_bank_row_stim.burst_size);       // burst size
        end
    endtask

endclass
