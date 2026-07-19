// Multiplier_tb.v  Jackson Robertson
// 4x4 Multiplier with serial input / serial output - Test Bench

module Multiplier_tb;

 // Inputs
 // Use 'reg' for ports that are driven/controlled by the test bench
 reg clock;
 reg reset;
 reg start;
 reg in;

 // Outputs
 // Use 'wire' for ports/variables driven/controlled by the module under test
 wire done;
 wire out;
 
 multiplier multiplier_00 (
  .clock(clock),
  .reset(reset),
  .start(start),
  .in(in),
  .done(done),
  .out(out)
 );

	initial begin
		clock = 0;
		forever #5 clock = ~clock;
	end

	initial begin
		reset=0; start=0; in=0;
		#10 reset=0; start=0; in=0;
		#10 reset=1; start=0; in=0;		

		#10 reset=1; start=1; in=0;
		#10 reset=1; start=0; in=0;
		#10 reset=1; start=0; in=0;
		#10 reset=1; start=0; in=1;
		#10 reset=1; start=0; in=0;
		#10 reset=1; start=0; in=0;
		#10 reset=1; start=0; in=0;
		#10 reset=1; start=0; in=1;
		#10 reset=1; start=0; in=1;
		#10 reset=1; start=0; in=0;
		
		#250;


		#10 reset=1; start=1; in=0;
		#10 reset=1; start=0; in=1;
		#10 reset=1; start=0; in=1;
		#10 reset=1; start=0; in=1;
		#10 reset=1; start=0; in=1;
		#10 reset=1; start=0; in=1;
		#10 reset=1; start=0; in=1;
		#10 reset=1; start=0; in=1;
		#10 reset=1; start=0; in=1;
		#10 reset=1; start=0; in=0;
		
		
		#250;


		#10 reset=1; start=1; in=0;
		#10 reset=1; start=0; in=0;
		#10 reset=1; start=0; in=0;
		#10 reset=1; start=0; in=0;
		#10 reset=1; start=0; in=0;
		#10 reset=1; start=0; in=0;
		#10 reset=1; start=0; in=0;
		#10 reset=1; start=0; in=0;
		#10 reset=1; start=0; in=0;
		
		#250;

		#10 $stop;
	end

	initial $monitor($time, " clock=%b, reset=%b, start=%b, in=%b, done=%b, out=%b", clock, reset, start, in, done, out);
endmodule

