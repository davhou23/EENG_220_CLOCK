module clock(CLK, P, STOP, MIN_IN, Q_MIN, Q_SEC, Q_MIL);
	parameter n = 4;
	
	input CLK, P, STOP;
	input [7:0] MIN_IN;
	output reg [n-1:0] Q_MIN, Q_SEC, Q_MIL;
	reg [26:0]slow;
	
	always@(posedge CLK) begin
		if (~P)begin
				Q_MIN <= MIN_IN;
		end
		if (STOP)begin
			slow <= slow + 1'b1;
			if (slow == 499999) begin
				slow <= 0;
			end
			if (slow == 0) begin
				if (Q_MIL == 8'b10011001) begin
					if (Q_SEC == 8'b01011001)begin
						if (Q_MIN == 8'b01011001) begin
							Q_MIN <= 8'b00000000;
							Q_SEC <= 8'b00000000;
							Q_MIL <= 8'b00000000;
						end
						
						else if (Q_MIN[3:0] == 9) begin
							Q_MIN[3:0] <= 0;
							Q_MIN[7:4] <= Q_MIN[7:4] + 1;
						end
						else begin
							Q_MIN <= Q_MIN + 1;
						end
						
						Q_SEC <= 8'b00000000;
						Q_MIL <= 8'b00000000;
					end
					else begin
						if (Q_SEC[3:0] == 9)begin
							Q_SEC[3:0] <= 0;
							Q_SEC[7:4] <= Q_SEC[7:4] + 1;
						end
						else begin
							Q_SEC <= Q_SEC + 1;
						end
					end
					
					Q_MIL <= 8'b00000000;
				end
				
				else begin
					if (Q_MIL[3:0] == 9) begin
						Q_MIL[3:0] <= 0;
						Q_MIL[7:4] <= Q_MIL[7:4] + 1;
					end
					else begin
						Q_MIL <= Q_MIL + 1'b1;
					end
				end
			end
		end
	end
	
endmodule 