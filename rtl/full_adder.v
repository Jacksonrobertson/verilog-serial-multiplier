// full_adder.v Jackson Robertson
// Full Adder gate

module full_adder ( input a , b , cin, output y , cout);
	wire d,e,f;
	half_adder2 a1 (a , b, d, e);
	half_adder2 a2 (cin, d, y, f);
	assign cout = f|e;
endmodule
