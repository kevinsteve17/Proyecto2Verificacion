class sdrcSB;
    int store[$]; // Deprecated for 2 version
    int unsigned store[int]; // Modified for aleatory tests
    int unsigned dir[$];
    int unsigned burstLenght[$];
    int ErrCnt;

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