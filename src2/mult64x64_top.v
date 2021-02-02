module mult64x64_top(
input          clk,
input          rstn,
input  [63:0]  oper_a,
input  [63:0]  oper_b,
output [127:0] final_p
);

reg [15:0] dataa, datab;
wire[31:0] result;
ip ip16x16(dataa, datab, result);

parameter IDLE = 16'b00000000_00000000,
		  A1B1 = 16'b00000000_00000001,
		  A1B2 = 16'b00000000_00000010,
		  A1B3 = 16'b00000000_00000100,
		  A1B4 = 16'b00000000_00001000,
		  A2B1 = 16'b00000000_00010000,
		  A2B2 = 16'b00000000_00100000,
		  A2B3 = 16'b00000000_01000000,
		  A2B4 = 16'b00000000_10000000,
		  A3B1 = 16'b00000001_00000000,
		  A3B2 = 16'b00000010_00000000,
		  A3B3 = 16'b00000100_00000000,
		  A3B4 = 16'b00001000_00000000,
		  A4B1 = 16'b00010000_00000000,
		  A4B2 = 16'b00100000_00000000,
		  A4B3 = 16'b01000000_00000000,
		  A4B4 = 16'b10000000_00000000;

reg [15:0] c_state, n_state;
always @(posedge clk or negedge rstn)begin
	if (!rstn)begin
		c_state <= IDLE;
	end
    else begin
		c_state <= n_state;
	end
end

reg  flag;
wire [63:0] oper_a_w = oper_a;
wire [63:0] oper_b_w = oper_b;
always @(c_state)begin
	case(c_state)
		IDLE:begin n_state = A1B1; dataa = 16'b0;           datab = 16'b0;           flag = 1'b0; end
		A1B1:begin n_state = A1B2; dataa = oper_a_w[15:0 ]; datab = oper_b_w[15:0 ]; flag = 1'b0; end
		A1B2:begin n_state = A1B3; dataa = oper_a_w[15:0 ]; datab = oper_b_w[31:16]; flag = 1'b0; end
		A1B3:begin n_state = A1B4; dataa = oper_a_w[15:0 ]; datab = oper_b_w[47:32]; flag = 1'b0; end
		A1B4:begin n_state = A2B1; dataa = oper_a_w[15:0 ]; datab = oper_b_w[63:48]; flag = 1'b0; end
		A2B1:begin n_state = A2B2; dataa = oper_a_w[31:16]; datab = oper_b_w[15:0 ]; flag = 1'b0; end
		A2B2:begin n_state = A2B3; dataa = oper_a_w[31:16]; datab = oper_b_w[31:16]; flag = 1'b0; end
		A2B3:begin n_state = A2B4; dataa = oper_a_w[31:16]; datab = oper_b_w[47:32]; flag = 1'b0; end
		A2B4:begin n_state = A3B1; dataa = oper_a_w[31:16]; datab = oper_b_w[63:48]; flag = 1'b0; end
		A3B1:begin n_state = A3B2; dataa = oper_a_w[47:32]; datab = oper_b_w[15:0 ]; flag = 1'b0; end
		A3B2:begin n_state = A3B3; dataa = oper_a_w[47:32]; datab = oper_b_w[31:16]; flag = 1'b0; end
		A3B3:begin n_state = A3B4; dataa = oper_a_w[47:32]; datab = oper_b_w[47:32]; flag = 1'b0; end
		A3B4:begin n_state = A4B1; dataa = oper_a_w[47:32]; datab = oper_b_w[63:48]; flag = 1'b0; end
		A4B1:begin n_state = A4B2; dataa = oper_a_w[63:48]; datab = oper_b_w[15:0 ]; flag = 1'b0; end
		A4B2:begin n_state = A4B3; dataa = oper_a_w[63:48]; datab = oper_b_w[31:16]; flag = 1'b0; end
		A4B3:begin n_state = A4B4; dataa = oper_a_w[63:48]; datab = oper_b_w[47:32]; flag = 1'b0; end
		A4B4:begin n_state = A1B1; dataa = oper_a_w[63:48]; datab = oper_b_w[63:48]; flag = 1'b1; end
		default:;
	endcase
end

reg [31:0] p11, p12, p13, p14, p21, p22, p23, p24, p31, p32, p33, p34, p41, p42, p43, p44;
always @(posedge clk or negedge rstn)begin
    if (!rstn)begin
        p11 <= 32'b0;
        p12 <= 32'b0;
        p13 <= 32'b0;
        p14 <= 32'b0;
        p21 <= 32'b0;
        p22 <= 32'b0;
        p23 <= 32'b0;
        p24 <= 32'b0;
        p31 <= 32'b0;
        p32 <= 32'b0;
        p33 <= 32'b0;
        p34 <= 32'b0;
        p41 <= 32'b0;
        p42 <= 32'b0;
        p43 <= 32'b0;
        p44 <= 32'b0;
    end
    else begin
        case(c_state)
            A1B1:p11 <= result;
            A1B2:p12 <= result;
            A1B3:p13 <= result;
            A1B4:p14 <= result;
            A2B1:p21 <= result;
            A2B2:p22 <= result;
            A2B3:p23 <= result;
            A2B4:p24 <= result;
            A3B1:p31 <= result;
            A3B2:p32 <= result;
            A3B3:p33 <= result;
            A3B4:p34 <= result;
            A4B1:p41 <= result;
            A4B2:p42 <= result;
            A4B3:p43 <= result;
            A4B4:p44 <= result;
            default;
        endcase
    end
end

wire [79:0] row1, row2, row3, row4; 
assign row1 = p11 + {p12, 16'b0} + {p13, 32'b0} + {p14, 48'b0};
assign row2 = p21 + {p22, 16'b0} + {p23, 32'b0} + {p24, 48'b0};
assign row3 = p31 + {p32, 16'b0} + {p33, 32'b0} + {p34, 48'b0};
assign row4 = p41 + {p42, 16'b0} + {p43, 32'b0} + {p44, 48'b0};

reg flag_w;
always @(posedge clk or negedge rstn)begin
    if(!rstn)begin
        flag_w <= 1'b0;
    end
    else begin
        flag_w <= flag;
    end
end

assign final_p = (flag_w)?(row1 + {row2, 16'b0} + {row3, 32'b0} + {row4, 48'b0}):final_p;

endmodule