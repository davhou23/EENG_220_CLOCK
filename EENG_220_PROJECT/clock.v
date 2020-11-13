module clock(CLK, P, STOP, SWITCH, SW_IN, Q_HOUR_ONE, Q_HOUR_TEN, Q_MIN_ONE, Q_MIN_TEN, Q_SEC_ONE, Q_SEC_TEN);
	input CLK, P, STOP, SWITCH;
	input [7:0] SW_IN;
	
	output [3:0] Q_HOUR_ONE, Q_HOUR_TEN, Q_MIN_ONE, Q_MIN_TEN, Q_SEC_ONE, Q_SEC_TEN;
	reg [7:0] SEC = 8'b00000000;
	reg [7:0] MIN = 8'b00000000;
	reg [7:0] HOUR = 8'b00010010; 
	reg [26:0] slow;
	
	always@(posedge CLK) begin
		if (~P)begin
			if (SWITCH) begin
				HOUR <= SW_IN;
			end
			else begin
				MIN <= SW_IN;
			end
		end
		if (STOP)begin
			slow <= slow + 1'b1;
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
	end
	
<<<<<<< HEAD
=======
	assign Q_HOUR_ONE = HOUR[3:0];
	assign Q_HOUR_TEN = HOUR[7:4];
	assign Q_MIN_ONE = MIN[3:0];
	assign Q_MIN_TEN = MIN[7:4];
	assign Q_SEC_ONE = SEC[3:0];
	assign Q_SEC_TEN = SEC[7:4];
	
>>>>>>> main
endmodule 