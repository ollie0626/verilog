
`include "counter.v"
// `include "220model.v"
`include "altera_mf.v"
// `include "altera_primitives.v"
// `include "cycloneiv_atoms.v"
`include "fifo.v"
// `include "sgate.v"

`timescale 1ns/1ps

module counter_tb;

reg clk;
reg rst_n;
wire shot_o;

reg [7:0] data_in;
reg rdreq, wrreq;
reg sclr;
wire [7:0] data_out;
wire empty_flg, full_flg;
wire [3:0] data_num;

always #1 clk = ~clk;

initial begin
    $dumpfile("main.vcd");
    $dumpvars(0);
    clk = 0;
    rst_n = 0;

    data_in = 8'hAA;
    rdreq = 1'b0;
    wrreq = 1'b0;
    sclr = 1'b0;
    rst_n = 1'b0;
end

initial begin
    #1 rst_n = 0;
    #1 rst_n = 1; wrreq = 1'b1;
    #2500; $finish;
end

always@(negedge clk or negedge rst_n) begin
    if(!rst_n)  data_in <= 8'hAA;
    else if (data_in <= 8'hFF && !rdreq) data_in <= data_in + 1'b1;
end

always@(posedge full_flg or negedge rst_n) begin
    if(!rst_n) rdreq <= 1'b0;
    else if(full_flg) begin
     rdreq <= 1'b1;
     wrreq <= 1'b0;
    end
end

counter u0(
    .clk            (clk),
    .rst_n          (rst_n),
    .en             (1'b1),
    .shot_o         (shot_o)
);


fifo u1(
	.clock      (clk),  // fifo clock
	.data       (data_in),     // fifo data_in
    .q          (data_out),     // fifo data_o
	.rdreq      (rdreq),     // read en
	.wrreq      (wrreq),     // write en
	.empty      (empty_flg),     // fifo empty flag
	.full       (full_flg),     // fifo full flag
	.usedw      (data_num)      // current write data number
);

endmodule

