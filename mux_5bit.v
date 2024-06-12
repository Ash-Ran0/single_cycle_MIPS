module mux_5bit(
    input sel,
    input [4:0] in_5_1,
    input [4:0] in_5_2,
    output [4:0] out_5
);

assign out_5 = (sel)  ? (in_5_1) : (in_5_2);

endmodule