
// multiplier4.v Jackson Robertson
// 4-bit Hierchical Multiplier.

module multiplier4 (input [7:0] in, output [7:0] out);

	wire [7:0] s;
	wire [3:0] a; 
	wire [3:0] b;
	wire [14:0] w;
	wire [10:0] c;
	wire [7:0] o;

	assign a = in[3:0];
	assign b = in[7:4];

	assign s[0] = b[0] & a[0];
	assign w[0] = b[0] & a[1];
	assign w[1] = b[0] & a[2];
	assign w[2] = b[0] & a[3];
	
	assign w[3] = b[1] & a[0];
	assign w[4] = b[1] & a[1];
	assign w[5] = b[1] & a[2];
	assign w[6] = b[1] & a[3];
	
	half_adder2 H0 (w[0], w[3], s[1], c[0]);
	full_adder F0 (w[1], w[4], c[0], o[0] , c[1]);
	full_adder F1 (w[2], w[5], c[1], o[1], c[2]);
	half_adder2 H1 (w[6], c[2], o[2], c[3]);
	
	assign w[7] = b[2] & a[0];
	assign w[8] = b[2] & a[1];
	assign w[9] = b[2] & a[2];
	assign w[10] = b[2] & a[3];
	
	half_adder2 H2 (w[7], o[0], s[2], c[4]);
	full_adder F2 (w[8], o[1], c[4], o[3], c[5]);
	full_adder F3 (w[9], o[2], c[5], o[4], c[6]);
	full_adder F4 (w[10], c[3], c[6], o[5],  c[7]);
	
	assign w[11] = b[3] & a[0];
	assign w[12] = b[3] & a[1];
	assign w[13] = b[3] & a[2];
	assign w[14] = b[3] & a[3];
	
	half_adder2 H3 (w[11], o[3], s[3], c[8]);
	full_adder F5 (w[12], o[4], c[8], s[4], c[9]);
	full_adder F6 (w[13], o[5], c[9], s[5], c[10]);
	full_adder F7 (w[14], c[7], c[10], s[6], s[7]);

	assign out[7:0] = s[7:0];
endmodule

