module ALU (
    input           clk,
    input   [2:0]   control_in,
    input   [31:0]  in1,
    input   [31:0]  in2,
    output reg [31:0]  alu_result,
    output          is_zero
);


    always @(*) begin
        case (control_in)
            3'b000: alu_result = in1 & in2;        //AND
            3'b001: alu_result = in1 | in2;        //OR
            3'b010: alu_result = in1 + in2;        //ADD
            3'b110: alu_result = in1 - in2;        //SUBSTRACT
            3'b111: alu_result = in1 < in2;        //if LESS than
            default: alu_result = 32'h0;
        endcase
    end

    assign is_zero = (alu_result==32'h0);           // 1. in1 == in2    2. in1==0 & in2==0 

endmodule 








