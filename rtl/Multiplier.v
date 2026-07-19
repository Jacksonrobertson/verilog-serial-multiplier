// controller.v  Jackson Robertson
// 4x4 Multiplier


module multiplier(input clock, reset, start, in, output done, out);

wire done_flag;
wire [7:0] out_0;
wire [7:0] out_1;
wire serial_in_en;
wire serial_out_en;

controller c1 (clock, reset, start, done_flag, serial_in_en, serial_out_en);

serial_in8 si (in, reset, clock, serial_in_en, out_0);

multiplier4 m1 (out_0, out_1);

serial_out8 so (out_1, reset, clock, serial_out_en, out);




assign done = done_flag;

endmodule
