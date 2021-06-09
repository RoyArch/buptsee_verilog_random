module twoseconds(input clk,
                    input rst,
                    input [11:0]ad,//from adc
                    input flag,//from adc
                    output reg convert,//to adc
                    output reg [11:0]num//to seg
                   );

  parameter cnt_top=21'd1999999;
  //parameter cnt_top=21'd1000;
  //generate 2s period
  reg [20:0]cnt;
  always@(posedge clk or posedge rst)
  begin
    if(rst)
      cnt<=0;
    else if(cnt==cnt_top)
      cnt<=0;
    else
      cnt<=cnt+21'b1;
  end

  //flag catch and read permission
  reg flag_catch;
  reg read_permission;
  always@(posedge clk or posedge rst)
  begin
    if(rst)
      flag_catch<=0;
    else
      flag_catch<=flag;
  end
  always@(posedge clk or posedge rst)
  begin
    if(rst)
      read_permission<=0;
    else if(flag_catch!=flag && flag)
      read_permission<=1;
    else
      read_permission<=0;
  end

  //convert
  reg[4:0] convert_cnt;
  always@(posedge clk or posedge rst)
  begin
    if(rst)
    begin
      convert_cnt<=5'b0;
    end
    else if(convert_cnt!=5'b11111)
      convert_cnt<=convert_cnt+5'b1;
    else
      convert_cnt<=0;
  end

  always@(*)
  begin
    if(convert_cnt==5'b11111)
      convert=1;
    else
      convert=0;
  end

  //num temp from adc and one_num_flag
  reg [3:0]num_temp;
  reg [1:0]one_num_flag;
  always@(posedge clk or posedge rst)
  begin
    if(rst)
    begin
      num_temp<=4'b0;
      one_num_flag<=2'b0;
    end
    else if(read_permission)
    begin
      num_temp<={num_temp[2:0],ad[0]};
      if(one_num_flag==2'b11)
        one_num_flag<=2'b00;
      else
        one_num_flag<=one_num_flag+2'b1;
    end
  end

  //write_permission and num_temp_3
  reg [11:0]num_temp_3;
  reg write_permission;
  reg [1:0]one_num_flag_catch;
  always@(posedge clk or posedge rst)
  begin
    if(rst)
      one_num_flag_catch<=2'b0;
    else
      one_num_flag_catch<=one_num_flag;
  end

  always@(posedge clk or posedge rst)
  begin
    if(rst)
    begin
      write_permission<=0;
    end
    else
    begin
      if(one_num_flag_catch==2'b11 && one_num_flag==2'b00)
        write_permission<=1;
      else
        write_permission<=0;
    end
  end

  always@(posedge clk or posedge rst)
  begin
    if(rst)
      num_temp_3<=12'b0;
    else if(write_permission && num_temp<=4'd9)
      num_temp_3[11:0]<={num_temp_3[7:0],num_temp[3:0]};
  end

  //num print
  always@(posedge clk or posedge rst)
  begin
    if(rst)
      num=12'b0;
    else
    begin
      if(cnt==cnt_top)
        num[11:0]<=num_temp_3[11:0];
    end
  end

endmodule
