module PCfeedback_branch_jump (
    //input clk,
    //input rst_,
    input [31:0] curr_inst_addr,
    input signed [31:0] extended_inst_offset,
    input signed [25:0] jump_inst_addr,
    input Branch,    
    input Jump,
    input ALU_zero,
    output reg [31:0] pc_input
);


    //branch adder
    wire [31:0] branch_target_addr;
    assign branch_target_addr = curr_inst_addr + (extended_inst_offset<<2);

    //jump adder
    wire [31:0] jump_target_inst_addr;
    assign jump_target_inst_addr = {curr_inst_addr[31:28], (jump_inst_addr<<2) };


    // branch mux
    wire branch_sel = Branch & ALU_zero;
    
    always @(*) begin
        case (branch_sel)
            1'b0: begin
                case (Jump)
                    1'b0: pc_input = curr_inst_addr;
                    1'b1: pc_input = jump_target_inst_addr;
                endcase
            end
            1'b1: pc_input = branch_target_addr;
            default : pc_input = curr_inst_addr;
        endcase
    end

   


endmodule


/* LATE for 1 T
    reg [31:0] branch_target_addr;
    always @(*) begin
            if (~rst_)
                branch_target_addr <= 0;
            else
                branch_target_addr <= curr_inst_addr + (extended_inst_offset<<2);
    end
*/


