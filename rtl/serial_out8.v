// serial_out8.v Jackson Robertson
// 8-bit Serial Output Shift Register with Synchronous Load and Active Low Asynchronous Reset.

module serial_out8 (input [7:0] in, input reset, clock, load, output out);
	reg q0, q1, q2, q3, q4, q5, q6, q7;
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
		end
		else
		begin
			q7 <= 0;
			q6 <= q7;
			q5 <= q6;
			q4 <= q5;
			q3 <= q4;
			q2 <= q3;
			q1 <= q2;
			q0 <= q1;
			if(load)
			begin
				q7 <= in[7];
				q6 <= in[6];
				q5 <= in[5];
				q4 <= in[4];
				q3 <= in[3];
				q2 <= in[2];
				q1 <= in[1];
				q0 <= in[0];
			end
		end
	end
	assign out = q0;

endmodule

