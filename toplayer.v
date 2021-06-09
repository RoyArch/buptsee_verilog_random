module toplayer(input clk,
                  input rst_btn,
                  input data,
                  output dclock,
                  output cs,
                  output [7:0]disp,
                  output [7:0]select);

wire rst;
wire [11:0]num_dilivery;
wire convert_dilivery;
wire flag_dilivery;
wire [11:0]ad_dilivery;

btnStable btn(
.btnIn(rst_btn),
.clk(clk),
.btnOut(rst)
);

seg three_segs(
.clk(clk),
.rst(rst),
.disp(disp),
.select(select),
.num(num_dilivery)
);

ads7816 adc(
    .data(data),
    .clk(clk),
    .rst(rst),
    .convert(convert_dilivery),
    .flag(flag_dilivery),
    .dclock(dclock),
    .cs(cs),
    .ad_out(ad_dilivery)
);

twoseconds ctrl(
    .clk(clk),
    .ad(ad_dilivery),
    .flag(flag_dilivery),
    .convert(convert_dilivery),
    .num(num_dilivery)
);

endmodule