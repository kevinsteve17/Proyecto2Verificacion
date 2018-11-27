class sdrcSB;
    int store[$]; // need modification to support R/W out of order
    int dir[$];
    int burstLenght[$];
    int ErrCnt;
    mem_base_object mem [*];


    task store_write();
    input [31:0] Address;
    input [7:0]  bl;
    input [31:0] data;
    begin
        mem_base_object  mem_obj = new();
        mem_obj.addr = Address;
        mem_obj.bl = bl;
        mem_obj.data = data; // this won't work ... different types ... 

        // write the data in the scoreboard
        mem[Address] = mem_obj;
    end
        
    endtask //

    task store_read();
    input [31:0] Address;
    input [7:0]  bl;
    mem_base_object  read_mem_obj = mem[Address];
    begin
        // read the data in the scoreboard
        // return read_mem_obj;

    end
    endtask //





    task clearStore();
        begin
            // clear the data in the scoreboard
            store = {};
            dir = {};
            burstLenght{};
            ErrCnt = 0;
        end
    endtask //automatic
endclass