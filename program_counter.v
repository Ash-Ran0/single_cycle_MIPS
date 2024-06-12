module program_counter (
    input clk,
    input rst_,
    input [31:0] pc_input,
    output reg [31:0] curr_inst_addr,
    output [31:0] next_inst_addr
);

// FF: store curr address
always @(posedge clk) begin
    if (~rst_)  curr_inst_addr <= 0;
    else        curr_inst_addr <= pc_input;
end

//adder
assign next_inst_addr = curr_inst_addr + 4'h4;






endmodule

