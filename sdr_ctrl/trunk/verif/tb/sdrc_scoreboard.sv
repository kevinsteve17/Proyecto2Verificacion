class sdrcSB;
    int store[$]; // need modification to support R/W out of order
    int dir[$];
    int burstLenght[$];
    int ErrCnt;


    task store_write(arguments);
    input [31:0] Address;
    input [7:0]  bl;
    begin
        // write the data in the scoreboard
    end
        
    endtask //

    task store_read(arguments);
    input [31:0] Address;
    input [7:0]  bl;
    begin
        // read the data in the scoreboard
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