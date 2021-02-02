`timescale 1ns/1ns
`define clk_period 12

module testbench;
reg clk;
reg rstn;
reg en;
reg [63:0] oper_a, oper_b;
wire [127:0] product, product_ref;

initial clk = 1;
always #(`clk_period/2) clk = ~clk;

initial begin
    rstn = 0;
    en = 0;
	 oper_a = 0;
    oper_b = 0;
    #(`clk_period);
    rstn = 1;
    repeat(100)begin
        oper_a = $random();
        oper_b = $random();
        en = 1;
        #(`clk_period*20);
        en = 0;
        #(`clk_period);
    end
    $stop;
end

reg [7:0] cnt;
initial begin
	cnt = 0;
	repeat(100)begin
		@(product)
		#(`clk_period)
		if(product == product_ref)begin
			cnt = cnt;
			$display("a = %h, b = %h, out = %h, out_ref = %h, Successfully!", oper_a, oper_b, product, product_ref);
		end
		else begin
			cnt = cnt + 1;
			$display("a = %h, b = %h, out = %h, out_ref = %h, Failed", oper_a, oper_b, product, product_ref);
		end
	end
end

/*// 分时复用16*16乘法器1个实现64*64乘法器 => 延迟16个周期输出
reg [127:0]product_ref_w[15:0];
always @(posedge clk or negedge rstn)begin
	if(!rstn)begin
		product_ref_w[0]  <= 128'b0;
		product_ref_w[1]  <= 128'b0;
		product_ref_w[2]  <= 128'b0;
		product_ref_w[3]  <= 128'b0;
		product_ref_w[4]  <= 128'b0;
		product_ref_w[5]  <= 128'b0;
		product_ref_w[6]  <= 128'b0;
		product_ref_w[7]  <= 128'b0;
		product_ref_w[8]  <= 128'b0;
		product_ref_w[9]  <= 128'b0;
		product_ref_w[10] <= 128'b0;
		product_ref_w[11] <= 128'b0;
		product_ref_w[12] <= 128'b0;
		product_ref_w[13] <= 128'b0;
		product_ref_w[14] <= 128'b0;
		product_ref_w[15] <=	128'b0;	
	end
	else begin
		product_ref_w[0]  <= product_ref;
		product_ref_w[1]  <= product_ref_w[0];
		product_ref_w[2]  <= product_ref_w[1];
		product_ref_w[3]  <= product_ref_w[2];
		product_ref_w[4]  <= product_ref_w[3];
		product_ref_w[5]  <= product_ref_w[4];
		product_ref_w[6]  <= product_ref_w[5];
		product_ref_w[7]  <= product_ref_w[6];
		product_ref_w[8]  <= product_ref_w[7];
		product_ref_w[9]  <= product_ref_w[8];
		product_ref_w[10] <= product_ref_w[9];
		product_ref_w[11] <= product_ref_w[10];
		product_ref_w[12] <= product_ref_w[11];
		product_ref_w[13] <= product_ref_w[12];
		product_ref_w[14] <= product_ref_w[13];
		product_ref_w[15] <= product_ref_w[14];
	end
end
	
reg [9:0]cnt;	
always @(posedge en)begin
	if(product == product_ref_w[15])begin
		cnt = 0;
		$display("oper_a = %h, oper_b = %h, product = %h, product_ref = %h, Successfully!",oper_a, oper_b, product, product_ref_w[15]);
	end
	else begin
		cnt = cnt + 1;
		$display("oper_a = %h, oper_b = %h, product = %h, product_ref = %h, Failed!",oper_a, oper_b, product, product_ref_w[15]);
	end
end
*/		

mult64x64_top mult64x64_top_u0(
    .clk     (clk    ),
    .rstn    (rstn   ),
    .en      (en     ),
    .oper_a  (oper_a ),
    .oper_b  (oper_b ),
    .final_p (product)
);

mult64x64_check mult64x64_check_u0(oper_a, oper_b, product_ref);

endmodule
