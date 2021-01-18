/*
	Name: David Hout
	Date: November 29
	Class: EENG 220
	Description: This module takes care of all the logic necesarry to get the 
	clock to tick. Essentially what happens is that clock counts one every second. Every 
	time the number reaches 60 seconds, it adds one to the minutes and displays it 
	to the clock. The same thing happens for the minutes and hours portion of the clock. 
*/

module clock(CLK, SWITCH, SW_IN, SET, TS_STATE, AS_STATE, Q_HOUR_ONE, Q_HOUR_TEN, Q_MIN_ONE, Q_MIN_TEN, Q_SEC_ONE, Q_SEC_TEN, QA_MIN_ONE, QA_MIN_TEN, QA_HOUR_ONE, QA_HOUR_TEN, A_ENABLE, B);
	//Initialize all the input variables
	input CLK, SWITCH, A_ENABLE, AS_STATE, TS_STATE, SET;
	input [7:0] SW_IN;
	
	//Initialize all the output variables
	output reg B;
	output [3:0] Q_HOUR_ONE, Q_HOUR_TEN, Q_MIN_ONE, Q_MIN_TEN, Q_SEC_ONE, Q_SEC_TEN, QA_MIN_ONE, QA_MIN_TEN, QA_HOUR_ONE, QA_HOUR_TEN;

	//Initialize all the register variables
	reg [7:0] SEC = 8'b00000000;
	reg [7:0] MIN = 8'b00000000;
	reg [7:0] HOUR = 8'b00010010; 
	reg [7:0] A_HOUR = 8'b00000110, 
			  A_MIN = 8'b00110000;
	reg [26:0] slow, a_slow;
	reg alarm_on, buzzer_on;
	
	
	always@(posedge CLK) begin
		//If we are setting either the clock or the alarm time
		if (~SET) begin
			//If the set time state is on
			if (TS_STATE)begin
				if(SWITCH)
					MIN <= SW_IN;
				else
					HOUR <= SW_IN;
			end
			//If the set alarm state is on
			else if (AS_STATE) begin
				if (SWITCH)
					A_MIN <= SW_IN;
				else
					A_HOUR <= SW_IN;
			end
		end
		
		//If we are not setting the clock or alarm time
		if (!(TS_STATE||AS_STATE))begin
			slow <= slow + 1'b1;
			//Every time the 50Mhz clock has run for one second, take one step in the clock logic.
			if (slow == 49999999) begin
				slow <= 0;
			end
			if (slow == 0) begin
				//If sec equals 59
				if (SEC == 8'b01011001) begin
					//If min equals 59
					if (MIN == 8'b01011001)begin
						//If hour equals 12
						if (HOUR == 8'b00010010)begin
							SEC <= 8'b00000000;
							MIN <= 8'b00000000;
							HOUR <= 8'b00000001;
						end
						
						//If the ones place equals 9 reset the ones place to zero and add one to the tens place
						else if (HOUR[3:0] == 8'b00001001) begin
							HOUR[3:0] <= 0;
							HOUR[7:4] <= 1;
						end
						else begin
							HOUR <= HOUR + 1;
						end
						
						//Reset Minutes
						MIN <= 0;
						
					end
					
					//If the ones place equals 9 reset the ones place and add 1 to the tens place
					else if (MIN[3:0] == 8'b00001001) begin
						MIN[3:0] <= 0;
						MIN[7:4] <= MIN[7:4] + 1;
					end
					else begin
						MIN <= MIN + 1;
					end
					
					//Reset Seconds
					SEC <= 0;
				end
				
				//If the ones place equals 9 reset the ones place and add 1 to the tens
				else if (SEC[3:0] == 8'b00001001)begin
						SEC[3:0] <= 0;
						SEC[7:4] <= SEC[7:4] + 1;
				end
				else begin
					SEC <= SEC + 1;
				end
			end
		end
		
		//Is the alarm enabled?
		if (A_ENABLE)begin
			//Is the alarm at the desired time?
			if (A_MIN == MIN && A_HOUR == HOUR)begin
				alarm_on <= 1;
			end
		end
		else begin
			alarm_on <= 0;
			buzzer_on <= 0;
			B <= 1;
		end
		
		//When the buzzer needs to be truned on
		if (alarm_on)begin
			a_slow <= a_slow + 1;
			if (a_slow == 24999999)begin
				if (buzzer_on)begin
					B <= 0;
					buzzer_on <= 0;
				end
				else begin
					B <= 1;
					buzzer_on <= 1;
				end
				a_slow <= 0;
			end
		end
	end
	
	assign Q_HOUR_ONE = HOUR[3:0];
	assign Q_HOUR_TEN = HOUR[7:4];
	assign Q_MIN_ONE = MIN[3:0];
	assign Q_MIN_TEN = MIN[7:4];
	assign Q_SEC_ONE = SEC[3:0];
	assign Q_SEC_TEN = SEC[7:4];
	assign QA_HOUR_ONE = A_HOUR[3:0];
	assign QA_HOUR_TEN = A_HOUR[7:4];
	assign QA_MIN_ONE = A_MIN[3:0];
	assign QA_MIN_TEN = A_MIN[7:4];
	
endmodule 