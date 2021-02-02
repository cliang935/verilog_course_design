`timescale 1ns/1ps

module ip_tb;
	reg clk;
	reg [15:0] dataa, datab;
	wire [31:0] result;
	
	initial clk = 0;
	always #1 clk = ~clk;
	
	always@(posedge clk)begin
		dataa <= $random();
		datab <= $random();
	end
	
	ip ip_16x16(dataa, datab, result);
endmodule