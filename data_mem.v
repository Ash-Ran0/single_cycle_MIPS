module data_mem (
    input clk,
    input MemWrite,
    input [31:0] data_addr,
    input [31:0] write_data,
    output [31:0] read_data    
);

    reg [31:0] RAM [0:127];


    assign read_data = RAM[data_addr[8:2]];  //LOAD: read from data_mem, load to register_file

    always @(posedge clk) begin
        if (MemWrite)
            RAM[data_addr[8:2]] <= write_data;   //STORE: read from register_file, store to data_mem 
    end

endmodule
