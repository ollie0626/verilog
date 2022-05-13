

module counter(
    input clk,
    input rst_n,
    input en,

    output shot_o

);

parameter up_pos = 8'h20;
reg [7:0] cnt;
reg shot;
reg shot_rst;
wire sys_rst;
assign shot_o = shot;
assign sys_rst = shot_rst & rst_n;

always@(posedge clk or negedge rst_n) begin
    if(~rst_n) cnt <= 8'h0;
    else if(en) cnt <= cnt + 1'b1;
    else cnt <= 0;
end

always@(posedge clk or negedge sys_rst) begin
    if(~sys_rst) shot <= 1'b0;
    else if(cnt >= 8'h5 && cnt <= 8'h20) shot <= 1'b1;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n) shot_rst <= 1'b0;
    else if (cnt >= 8'h5 && cnt <= 8'h20) shot_rst <= 1'b1;
    else shot_rst <= 1'b0;
end


endmodule

