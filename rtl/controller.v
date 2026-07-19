// controller.v  Jackson Robertson
// 4x4 Multiplier FSM Controlle


module controller(input clock, reset, start, output done_flag, serial_in_en, serial_out_en);

	// Define our states using the 'parameter' construct
	// Names should be readable (to you) based on state function/purpose
	// We need at least 3 bits to cover 5-8 states ((see: one-hot FSM encoding as alternative)
	// Assigned numerical value is somewhat arbitrary at this point 
	//
	parameter  	STATE_IDLE = 3'b111; 	// IDLE state
  	parameter	STATE_Input = 3'b110; 	// start recived, inputting data
  	parameter	STATE_Mult = 3'b101; 	// Tmultiplying data
  	parameter	STATE_Output = 3'b100; 	// outputing over serial
	
	// Internal variables
	reg [2:0] CURRENT_STATE;
	reg [2:0] NEXT_STATE;
	
	reg [2:0] Q;
	wire[2:0] Count;
	reg count_reset;
	reg done; 
	reg serial_in;
	reg serial_out;
	
	// Our first always block executes an FSM state transistion every rising clock edge.
	// FWIW, this could also be the last always block, or the middle one; doesn't matter.
	// Why? All always blocks run in parallel, always.
	// This also performs synchronous rest; for asynch reset, always@(posedge clk, posedge rst).
	// Our reset signal 'rst' is active low (i.e. reset the FSM when rst=0).
	//
	always @(posedge clock)
	begin
 		if(~reset) 
 			CURRENT_STATE <= STATE_IDLE;
 		else
 			CURRENT_STATE <= NEXT_STATE; 
	end 


	// This always block figures out the next FSM state based on current state and input(s)
	// You could also usually use always @(*), since we want a combinational logic block
	// As written, also fine, it makes sense that we need to compute a next state anytime 
	//// the state changes, or anytime the input changes.
	//
	// Using a 'case' statement is a very clean way to organize this.
	// Be sure to have a default state! 
	// Why? We are only using 5 states, but 3 bits will be needed to encode them; 3 of 8 states undefined. 
	// We could be in an undefined state at power-on and have no way out until reset.
	//
	
	always @(posedge clock)
	begin
	if (reset == 0 || count_reset == 1)
	begin
		Q <= 3'b000;
	end
	else
	begin
 		Q[0] <= ~Q[0];
		Q[1] <= Q[0] ^ Q[1];
		Q[2] <= Q[2] ^ (Q[1] & Q[0]);
	end
	end
	assign Count = Q;
	
	always @(*)
	begin
	count_reset = 0;
	case(CURRENT_STATE) 
 		STATE_IDLE:	begin
  				if(start==1)
  				begin
  					count_reset = 1;
   					NEXT_STATE = STATE_Input;
   				end
  				else
  				begin
   					NEXT_STATE = STATE_IDLE;
   				end
 				end
 
 		STATE_Input:	begin
  				if(Count==3'b111)
  				begin
  					count_reset = 1;
   					NEXT_STATE = STATE_Mult;
   				end
  				else
  				begin
  					count_reset = 0;
  	 				NEXT_STATE = STATE_Input;
 				end
 				end

 		STATE_Mult:	begin
  					count_reset = 1;
   					NEXT_STATE = STATE_Output;
 				end 
 
 		STATE_Output:	begin
  				if(Count==3'b111)
  				begin
  					count_reset = 1;
  	 				NEXT_STATE = STATE_IDLE;
  	 			end
  				else
  				begin
  					count_reset = 0;
   					NEXT_STATE = STATE_Output;
   				end
 				end
 
 		default:	NEXT_STATE = STATE_IDLE;
 
 	endcase
	end


	// This always block just assigns the output(s) for each state
	// As you can see, this is a Moore FSM; state alone determines output value(s)
	// Be sure to include a default!
	always @(CURRENT_STATE)
	begin 
 	case(CURRENT_STATE) 
 		STATE_IDLE: 
 		begin
 			done = 0;	serial_in = 0;		serial_out = 0;
 		end
 		STATE_Input:
 		begin
 		   	done = 0;	serial_in = 1;		serial_out = 0;
 		end
 		STATE_Mult:
 		begin
 		  	done = 0;	serial_in = 0;		serial_out = 1;
 		end
 		STATE_Output:
 		begin
 		  	done = 1;	serial_in = 0;		serial_out = 0;
 		end
 		
 		default:
 		begin
 		  	done = 0;	serial_in = 0;		serial_out = 0;
 		end
 	endcase
	end
	
	// Outside of an always statement, so just a direct wiring
	// This just wires out internal variable to the _tb.v output port
	assign done_flag = done;
	assign serial_in_en = serial_in;
	assign serial_out_en = serial_out;
endmodule

