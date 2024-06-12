module ALUcontrol (
    input [5:0] inst_funct,
    input [1:0] ALUop,
    output reg [2:0] ALU_selection_input
);


/* ALUcontrol truth table
    input:      inst_funt (instruction[5:0])    , 6 bits
    selection:  ALUOp from Control unit         , 2 bits
    output:     ALU_selection_input             , 3 bits

operation       inst_opcode     inst_funct      selection   ALU_Action      ALU_selection_input
load word       LW              xxxxxx          00          ADD             010
store word      SW              xxxxxx          00          ADD             010
branch equal    Beq             xxxxxx          01          SUBTRACT        110
add             R-type          100000          10          ADD             010
subtract        R-type          100010          10          SUBTRACT        110
AND             R-type          100100          10          AND             000
OR              R-type          100101          10          OR              001
less than       R-type          101010          10          LESS than       111

*/


always @(*) begin
    case (ALUop) 
        2'b00:      ALU_selection_input = 3'b010;
        2'b01:      ALU_selection_input = 3'b110;
        2'b10:  begin
            case (inst_funct)
                6'b100000:  ALU_selection_input = 3'b010;
                6'b100010:  ALU_selection_input = 3'b110;
                6'b100100:  ALU_selection_input = 3'b000;
                6'b100101:  ALU_selection_input = 3'b001;
                6'b101010:  ALU_selection_input = 3'b111;
                default:    ALU_selection_input = 3'bxxx;       //to improve debugging
            endcase
        end
        default:    ALU_selection_input = 3'bxxx;               //to improve debugging
    endcase
end



endmodule