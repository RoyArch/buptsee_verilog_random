module seg(input clk,
             input rst,
             input [11:0] num,//3*8421BCD
             //input dot,
             output wire [7:0] disp,
             output reg [7:0]select);
  //add a segment selection signal

  reg [3:0]oneNum;
  assign dot=1'b0;
  
  segDecoder oneseg(
               .dot(dot),
               .num(oneNum),
               .disp(disp)
             );

  //select 2 down to 0 scan
  always@(posedge clk or posedge rst)
  begin
    if(rst)
      select<=8'b11111111;
    else
    begin
      case(select)
        8'b11111111:
          select<=8'b11110111;
        8'b11110111:
          select<=8'b11111011;
        8'b11111011:
          select<=8'b11111101;
        8'b11111101:
          select<=8'b11110111;
        default:
          select<=8'b11111111;
      endcase
    end
  end

  //oneNum
  reg [1:0]cntNum;
  always@(posedge clk or posedge rst)
  begin
    if(rst)
    begin
      cntNum<=2'b0;
    end
    else
    begin
      case(cntNum)
        2'd0:
          cntNum<=2'd1;
        2'd1:
          cntNum<=2'd2;
        2'd2:
          cntNum<=2'd3;
        2'd3:
          cntNum<=2'd1;
      endcase
    end
  end
  always@(*)
  begin
    case(cntNum)
      2'd0:
        oneNum=4'b0;
      2'd1:
        oneNum=num[11:8];
      2'd2:
        oneNum=num[7:4];
      2'd3:
        oneNum=num[3:0];
    endcase
  end


endmodule

