module MIPS_CPU (
    input clk,
    input rst_
);



wire [31:0] curr_inst_addr, next_inst_addr, pc_input;
program_counter PC(clk, rst_, pc_input, curr_inst_addr, next_inst_addr);
wire [31:0] instruction;
instruction_mem IMem(clk, curr_inst_addr, instruction);

wire RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump;
wire [1:0] ALUop;
control_unit CU (instruction[31:26], RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, ALUop);

wire [31:0] read_mem_data;
wire [ 4:0] write_rf_addr;
wire [31:0] write_rf_data;
wire [31:0] alu_result;
mux_5bit mux_RegDst(RegDst, instruction[15:11], instruction[20:16], write_rf_addr);
//assign write_rf_addr = (RegDst)  ? (instruction[15:11]) : (instruction[20:16]);
mux_32bit mux_MemtoReg(MemtoReg, read_mem_data, alu_result, write_rf_data);
//assign write_rf_data = (MemtoReg)? (read_mem_data)      : (alu_result);z

wire [31:0] read_reg1, read_reg2;
register_file RegFile(clk, RegWrite, instruction[25:21], instruction[20:16], write_rf_addr, write_rf_data, read_reg1, read_reg2);

wire [31:0] alu_in2;
wire [31:0] extended_inst_offset;
signed_extend s(instruction[15:0], extended_inst_offset);
//assign extended_inst_offset = { {16{instruction[15]}} ,instruction[15:0]};
mux_32bit mux_ALUSrc(ALUSrc, extended_inst_offset, read_reg2, alu_in2);
//assign alu_in2 = (ALUSrc) ? (extended_inst_offset) : (read_reg2);

wire [2:0] ALU_selection;
ALUcontrol alu_ctrl (instruction[5:0], ALUop, ALU_selection);
wire is_zero;
ALU alu_(clk, ALU_selection, read_reg1, alu_in2, alu_result, is_zero);

data_mem DMem(clk, MemWrite, alu_result, read_reg2, read_mem_data);

PCfeedback_branch_jump pc_feedback( next_inst_addr, extended_inst_offset, instruction[25:0], Branch, Jump, is_zero, pc_input);



endmodule