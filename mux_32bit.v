module mux_32bit(
    input sel,
    input [31:0] in_32_1,
    input [31:0] in_32_2,
    output [31:0] out_32
);

assign out_32 = (sel)  ? (in_32_1) : (in_32_2);

endmodule