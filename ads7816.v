//设置文件的时候记得统一时钟
module ads7816(input data,         //from ad
                 input clk,        //from controller
                 input rst,        //from controller
                 input convert,    //from controller
                 output  flag,  //to controller
                 output wire dclock,//to ad
                 output reg cs,    //to ad
                 output reg[11:0]ad_out); //to controller
  //convert posedge->cs negedge

parameter count_end_time=4'd13;

  assign dclock=clk;

  //cs
  reg temp_convert;
  always@(posedge clk or posedge rst)
  begin
    if(rst)
      cs<=1;
    else
    begin
      if(temp_convert!=convert)
        cs<=0;//when convert posedge,pull down cs
      else if(clk_count==count_end_time)
        cs<=1;//when convert finish,pull up cs
      temp_convert<=convert;
    end
  end

  //data the forth to the fifth clk posedge is available
  //ad_out flag
  reg [3:0]clk_count;
  always@(posedge clk or posedge rst)
  begin
    if(rst)
      clk_count<=4'b0;
    else if(clk_count==count_end_time)
      clk_count<=4'd0;
    else if(cs==0)
      clk_count<=clk_count+4'b1;
  end

 always@(posedge clk or posedge rst)
 begin
   if(rst)
   begin
     ad_out<=12'h0;
   end
   else if(cs==0)
     ad_out<={ad_out[10:0],data};
 end

// //test
// always@(posedge clk or posedge rst)
// begin
// if(rst)
// ad_out<=12'h0;
// else if(ad_out==12'hFFF)
// ad_out<=12'h0;
// else ad_out<=ad_out+12'h1;
// end

//  always@(posedge clk or posedge rst )
//  begin
//    if(rst)
//      flag<=0;
//    else if(clk_count==count_end_time)
//      flag<=1;
//    else if(cs==0)
//      flag<=0;
//  end
assign flag=cs;

endmodule
