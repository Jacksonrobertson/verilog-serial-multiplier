// multiplier4_tb.v  Jackson Robertson
// 4 Bit combinational multiplier - Test Bench


module multiplier4_tb;

 // Inputs
 // Use 'reg' for ports that are driven/controlled by the test bench

 reg [7:0] in;

 // Outputs
 // Use 'wire' for ports/variables drive/controlled by the module under test
 wire [7:0] out;


 multiplier4 multiplier4_00 ( 
  .in(in),
  .out(out)
 );
 
 initial 
 begin
    in = 8'b00000000;
    #10;
    in = 8'b1111_1111; 
    #10;  
    in = 8'b1010_1010;
    #10;   
    #10 $finish;
 end
 
  initial begin
  $monitor("t=%0t in=%b out=%b", $time, in, out);
end
  
endmodule

