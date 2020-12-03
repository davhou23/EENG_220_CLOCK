// This is a module to display on a Lucky Lite Model No. KW4-56NCWB-PY
// Derek Elam 11/16/2020
module Display (mhz10clock, m1, m10, h1, h10, DisplayGround, inputDisplay);
	input [3:0] m1, m10, h1, h10; // a four bit input from the clocks.
	input mhz10clock;
	// input [1:0] SW;
	output [4:0] DisplayGround;
	output [6:0] inputDisplay;// display[0] is A display [1] is B ... display[6] is G
	//went to 01 MHZ clock because wasnt very bright. 
//	assign Clock = ADC_CLK_10;
	wire [3:0] fourbit, h1, h10, m1, m10;
	wire [1:0] select;
//	reg [4:0] count;
	wire Slowclock;
	assign reset = 1'b1;
	
	//(Clock, Reset_n, enable, rollover); reset wasn't assigned to anything
	
	SlowClock c1(.Clock(mhz10clock), .Reset(reset), .SlowClock(Slowclock));
		defparam c1.k = 8000;//approx. 1200hz
		
	fourbit7seg D0(fourbit, inputDisplay);
	
	// testing will take out at the final part.
	
	shiftgroundsFSM FSM0(Slowclock, 1'b1, DisplayGround, h10, h1, m10, m1, fourbit); //select output port (2-bit vector)

endmodule	

module fourbit7seg (fourbit, display);
	input [3:0] fourbit;
	output [0:6] display;

	reg [0:6] display;

	always @fourbit begin
		case (fourbit)
		//							  7'bGFEDCBA  1 is light up
			4'b0000: display <= 7'b0111111;
			4'b0001: display <= 7'b0000110;
			4'b0010: display <= 7'b1011011;
			4'b0011: display <= 7'b1001111;
			4'b0100: display <= 7'b1100110;
			4'b0101: display <= 7'b1101101;
			4'b0110: display <= 7'b1111101;
			4'b0111: display <= 7'b0000111;
			4'b1000: display <= 7'b1111111;
			4'b1001: display <= 7'b1101111;
		endcase
	end
endmodule 



module shiftgroundsFSM(Clk, reset, DisplayGround, h10, h1, m10, m1, fourbit);
	input Clk, reset;
	output reg [4:0] DisplayGround, fourbit; 
	input [4:0] h10, h1, m10, m1;
			// DisplayGround: grounding 
			// pin 14 - display 1 (tens digit hour), 
			// pin 11 - display 2 (ones digit hour) 
			// pin 7  - display colon, 
			// pin 10 - display 3 (tens min)
			// pin 6  - display 4 (ones min)
	localparam [2:0] state_display_init = 0,
						  state_display0 = 1,
						  state_display1 = 2,
						  state_display2 = 3,
					     state_display3 = 4,
						  state_display4 = 5;
	reg [2:0] statein;
	
	always @(posedge Clk) begin
		if(~reset) begin //State reset had a pos reset and slowclock had negative
			statein = state_display_init;
		end
		else begin //next states
			case(statein)
				state_display0: begin
					statein = state_display1;
				end
				state_display1: begin
					statein = state_display2;
				end
				state_display2: begin
					statein = state_display3;
				end
				state_display3: begin
					statein = state_display4;
				end
				state_display4: begin
					statein = state_display0;
				end
				default: begin
				   statein = state_display0;
			   end
			endcase
		end
		
		//State Actions
		// Not sure which way to do it 0 being ground or 1.
		// needs testing in the lab
		case(statein)
			state_display0: begin // min ones
				DisplayGround[4:0] = 5'b11110;
				fourbit = m1;
			end
			state_display1: begin //min tens
				DisplayGround[4:0] = 5'b11101;
				fourbit = m10;
			end
			state_display2: begin // colon
				DisplayGround[4:0] = 5'b11011;
				fourbit = 4'b1000; // error detection 
			end
			state_display3: begin //hour one
				DisplayGround[4:0] = 5'b10111;
				fourbit = h1;
			end
			state_display4: begin //hour ten
				DisplayGround[4:0] = 5'b01111;
				fourbit = h10;
			end
			default: begin
				DisplayGround[4:0] = 5'b11110;
				fourbit = m1;
			end
		endcase
	end
endmodule 

module SlowClock(Clock, Reset, SlowClock);
    input Clock, Reset;
    output SlowClock;
    reg [27:0]counter;//size needed to hold 8000
	 parameter k = 20; //how many times slower the clock is
    always@(posedge Clock)begin
        if (~Reset) begin
            counter <= 'd0;
        end 
        else begin
            counter <= counter + 1;
            if(counter == k-1)begin //1250HZ
               counter <= 'd0;
				end
				else begin
               counter <= counter + 1'b1;	
				end
        end
    end
	 assign SlowClock = (counter == k-1);
endmodule 