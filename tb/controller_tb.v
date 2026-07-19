// controller_tb.v  Jackson Robertson
// 4 Bit combinational multiplier FSM controller - Test Bench


module controller_tb;

 // Inputs
 // Use 'reg' for ports that are driven/controlled by the test bench

 reg clock;
 reg reset;
 reg start;

 // Outputs
 // Use 'wire' for ports/variables drive/controlled by the module under test
 wire done_flag;
 wire serial_in_en;
 wire serial_out_en;

  controller controller_00 (
  .clock(clock),
  .reset(reset),
  .start(start),
  .done_flag(done_flag),
  .serial_in_en(serial_in_en),
  .serial_out_en(serial_out_en)
 );
 
 initial begin
  clock = 0;
  forever #5 clock = ~clock;
end

 initial
 begin
  reset = 0;
  start = 0;
  #10 reset = 1;//IDLE

  #10 start = 1; //INPUT
  #10 start = 0;

  #250; // MULT

  #10 start = 1; //OUTPUT
  #10 start = 0;

  #250;
  $finish;
 end

 initial begin
 $monitor("t=%0t reset=%b start=%b done=%b serial_in_en=%b serial_out_en=%b",
           $time, reset, start, done_flag, serial_in_en, serial_out_en);
end

endmodule

