// serial_out8_tb.v  Jackson Robertson
// 8 Bit Paralell Input Serial Output - Test Bench


module serial_out8_tb;

 // Inputs
 // Use 'reg' for ports that are driven/controlled by the test bench
 reg clock;
 reg reset;
 reg load;
 reg [7:0] in;

 // Outputs
 // Use 'wire' for ports/variables drive/controlled by the module under test
 wire out;


 serial_out8 serial_out8_00 (
  .load(load), 
  .clock(clock), 
  .reset(reset), 
  .in(in),
  .out(out)
 );
 
 initial 
 begin
 clock = 0;
 forever #5 clock = ~clock;
 end 
 
 initial 
 begin
  in = 8'b00000000; reset = 0; load = 0;
  #10 reset = 1;
  #10 in = 8'b11111111; load = 1;
  #10 load = 0;
  #80;
 
  #10 in = 8'b00000000; load = 1;
  #10 load = 0;
  #80;
  
  #10 in = 8'b10101010; load = 1;
  #10 load = 0;
  #80;
  #10 reset = 0;
  
  #10 $finish;
 end
 
  initial begin
  $monitor("t=%0t reset=%b load=%b in=%b out=%b", $time, reset, load, in, out);
end
  
endmodule

