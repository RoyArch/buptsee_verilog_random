module segDecoder(input [3:0] num,
                  input dot,
                  output reg [7:0] disp);

always @(num or dot) begin
    case(num)
        4'd0:disp[7:1]    = 7'b1111110;
        4'd1:disp[7:1]    = 7'b0110000;
        4'd2:disp[7:1]    = 7'b1101101;
        4'd3:disp[7:1]    = 7'b1111001;
        4'd4:disp[7:1]    = 7'b0110011;
        4'd5:disp[7:1]    = 7'b1011011;
        4'd6:disp[7:1]    = 7'b1011111;
        4'd7:disp[7:1]    = 7'b1110000;
        4'd8:disp[7:1]    = 7'b1111111;
        4'd9:disp[7:1]    = 7'b1111011;
        default:disp[7:1] = 7'b0000000;
        
    endcase
    if (dot) disp[0] = 1'b1;
    else disp[0]     = 1'b0;
end

endmodule
