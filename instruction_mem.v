module instruction_mem (
    input clk,
    input [31:0] read_addr,
    output reg [31:0] instruction
);

    /* 
    address range from 0 - 2^32-1, 
    so theoretically ROM max size is reg [31:0] ROM [2^32-1:0];
    but we usually allocate max size: reg [31:0] ROM [1023:0];
    */
    reg [31:0] ROM [0:1023]; 


    /*  
    instruction memory is ROM,
    ROM is combinational logic,
    NOT sequential logic!
    if use clk, 
    read out instruction will be 1 T late
    */ 

    always @(*) begin
        instruction = ROM[read_addr[31:2]]; 
    end

    /*  
        inst_memory address unit: word (word aligned)
        cause, in convention, all memory are byte-accessable, 
        (i.e. we read byte data from data memory),
        and if we want to access word-data (i.e. instruction here),
        we need to read 4 byte once (in 1 T),
        and thus, program counter will add 4 every cycle to fetch next instruction
        (next instruction start at 4 bytes away (1 word a way))
    */


endmodule

