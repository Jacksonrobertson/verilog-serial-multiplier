// half_adder2.v Jackson Robertson
// 2-input Half Adder gate

module half_adder2 ( input a , b , output y , c) ;
	assign y = a ^ b ;
	assign c = a & b ;
endmodule
