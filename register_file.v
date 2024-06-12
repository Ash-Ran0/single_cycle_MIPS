module register_file(
    input   clk,
    input   RegWrite,
    input   [4:0]     read_reg1_addr,
    input   [4:0]     read_reg2_addr,
    input   [4:0]     write_reg_addr,
    input   [31:0]    write_data,
    output  [31:0]    read_data1,
    output  [31:0]    read_data2
);


    reg [31:0] RF [0:31];       //address range: [4:0] = 2^N = 2^5 = 32; 
                                //reg [31:0] RF [0:31]: RF can store: 0-31 total 32 registers, each register size [31:0] 


    //LOAD: read from data_mem, load to register_file
    assign read_data1 = (read_reg1_addr==0) ? 0 : RF[read_reg1_addr];    //consideing zero instruction
    assign read_data2 = (read_reg2_addr==0) ? 0 : RF[read_reg2_addr];

    //STORE: read from register_file, store to data_mem
    //R-type: read from register_file, send to ALU compute, store back to register_file
    always @(posedge clk) begin
        if (RegWrite)
            RF[write_reg_addr] <= write_data;
    end


endmodule



