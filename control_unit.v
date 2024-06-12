module control_unit(
    input [5:0]     inst_opcode,
    output reg         RegDst,       //selection of mux to register_file write_addr; 0:rt, 1:rd
    output reg         ALUSrc,       //selection of mux to ALU in2; 0:reg2, 1:extended_offset
    output reg         MemtoReg,     //selection of mux to register_file write_data; 0:ALU_result, 1:read from DMem
    output reg         RegWrite,     //#write enable of register_file; 0:disable, 1:enable
    output reg         MemRead,      //#read enable of data_memory; 0:disable, 1:enable
    output reg         MemWrite,     //#write enable of data_memory; 0:disable, 1:enable
    output reg         Branch,       //#if instruction is Beq;  1: is beq
    output reg         Jump,        //#jump to another instruction
    output reg [1:0]   ALUop         //control of ALU_control unit
);

/* control unit truth table

operation       inst_opcode     RegDst              ALUSrc                  MemtoReg                    ALUop   RegWrite    MemRead     MemWrite    Branch
load word       100011          0 (write_addr=rt)   1 (base+offset)         1 (write_reg = read Dmem)   00      1           1           0           0
store word      101011          x                   1 (base+offset)         x                           00      0           0           1           0
branch equal    000100          x                   0 (compare reg1 reg2)   x                           01      0           0           0           1
r-type          000000          1 (write_addr=rd)   0 (compute reg1 reg2)   0 (write_reg = ALU result)  10      1           0           0           0
*/

always @(*) begin
    case (inst_opcode)
        6'b100011:  begin       //LW
                    RegDst      = 1'b0;
                    ALUSrc      = 1'b1;
                    MemtoReg    = 1'b1;
                    RegWrite    = 1'b1;
                    MemRead     = 1'b1;
                    MemWrite    = 1'b0;
                    Branch      = 1'b0;
                    ALUop       = 2'b00;
                    Jump        = 1'b0;
                    end
        6'b101011:  begin       //SW
                    RegDst      = 1'bx;   //
                    ALUSrc      = 1'b1;
                    MemtoReg    = 1'bx;  //
                    RegWrite    = 1'b0;
                    MemRead     = 1'b0;
                    MemWrite    = 1'b1;
                    Branch      = 1'b0;
                    ALUop       = 2'b00;
                    Jump        = 1'b0;
                    end
        6'b000100:  begin       //BEQ
                    RegDst      = 1'bx;   //
                    ALUSrc      = 1'b0;
                    MemtoReg    = 1'bx;   //
                    RegWrite    = 1'b0;
                    MemRead     = 1'b0;
                    MemWrite    = 1'b0;
                    Branch      = 1'b1;
                    ALUop       = 2'b01;
                    Jump        = 1'b0;
                    end
        6'b000000:  begin       //R-type
                    RegDst      = 1'b1;
                    ALUSrc      = 1'b0;
                    MemtoReg    = 1'b0;
                    RegWrite    = 1'b1;
                    MemRead     = 1'b0;
                    MemWrite    = 1'b0;
                    Branch      = 1'b0;
                    ALUop       = 2'b10;
                    Jump        = 1'b0;
                    end
        6'b000010: begin        //JUMP
                    RegDst      = 1'bx; //
                    ALUSrc      = 1'bx; //
                    MemtoReg    = 1'bx; //
                    RegWrite    = 1'b0;
                    MemRead     = 1'b0;
                    MemWrite    = 1'b0;
                    Branch      = 1'b0;
                    ALUop       = 2'bxx; //
                    Jump        = 1'b1;
                    end
        default:    begin               //invalid op
                    RegDst      = 1'bx;
                    ALUSrc      = 1'bx;
                    MemtoReg    = 1'bx;
                    RegWrite    = 1'bx;
                    MemRead     = 1'bx;
                    MemWrite    = 1'bx;
                    Branch      = 1'bx;
                    ALUop       = 2'bxx;
                    Jump        = 1'bx;
                    end
    endcase
end


endmodule