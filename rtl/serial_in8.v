
// serial_in8.v Jackson Robertson
// 8-bit Serial Input Shift Register with Synchronous Load and Active Low Asynchronous Reset.

module serial_in8 (input in, reset, clock, load, output [7:0] out);
	reg q0, q1, q2, q3, q4, q5, q6, q7;
	reg l0, l1, l2, l3, l4, l5, l6, l7;
	always @(posedge clock or negedge reset)
	begin

		if(!reset)
		begin
			q7 <= 0;
			q6 <= 0;
			q5 <= 0;
			q4 <= 0;
			q3 <= 0;
			q2 <= 0;
			q1 <= 0;
			q0 <= 0;
			l7 <= 0;
			l6 <= 0;
			l5 <= 0;
			l4 <= 0;
			l3 <= 0;
			l2 <= 0;
			l1 <= 0;	
			l0 <= 0;
		end
		else
		begin
			q7 <= q6;
			q6 <= q5;
			q5 <= q4;
			q4 <= q3;
			q3 <= q2;
			q2 <= q1;
			q1 <= q0;
			q0 <= in;
			if(load)
			begin
				l7 <= q6;
				l6 <= q5;
				l5 <= q4;
				l4 <= q3;
				l3 <= q2;
				l2 <= q1;
				l1 <= q0;
				l0 <= in;
			end
		end
	end
	assign out = {l7, l6, l5, l4, l3, l2, l1, l0};

endmodule

