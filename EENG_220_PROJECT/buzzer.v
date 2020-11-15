module buzzer(ENABLE, CLK, BUZZER)
    input ENABLE, CLK;

    output reg BUZZER;
    parameter n = 10;

    reg [n:0] SLOW;

    always @(posedge CLK) begin
        SLOW <= SLOW + 1;
        if (SLOW == 0)begin
            BUZZER <= 1;
        end
        else begin
            BUZZER <= 0;
        end
    end
endmodule