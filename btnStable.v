module btnStable(input wire btnIn,
                   input wire clk,
                   output reg btnOut);
  //clk freq=1MHz period=1us
  reg [14:0] timeCount;
  reg temp;
   always@(posedge clk)
   begin
     if(timeCount==15'b0)
     begin
       if(temp!=btnIn)
         btnOut=~btnOut;
       timeCount<=15'b11111111111111;
     end
     else
     begin
	  if(timeCount!=15'b0)
       timeCount<=timeCount-15'b1;
     end
     temp<=btnIn;
  end

endmodule
