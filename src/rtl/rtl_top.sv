module rtl_top #(
	N = 4,
	gen_num 	= 1500
) (
	input logic clk,
	input logic rst_n,
	input logic 		[15:0]			a_i,
	input logic 		[N-1:0]			b_i,
	input logic 						vld_i,
	output logic 		[31: 0] 		c_o,
	output logic 						result_vld_o
);

	logic 		[15:0]			a[gen_num];
	logic 		[N-1:0]			b[gen_num];
	logic 						vld[gen_num];
	logic 		[31: 0] 		c[gen_num];
	logic 						result_vld[gen_num];

	always_comb begin 
		c_o = '0;
		result_vld_o = '0;
		for (int i = 0; i < gen_num; i++) begin 
			c_o += c[i];
			result_vld_o &= result_vld[i];
		end 
	end 

	genvar i;
	generate
		for(i = 0; i < gen_num; i++) begin : why_does_this_need_a_name
			assign a[i]				= a_i;
			assign b[i]				= b_i;
			assign vld[i]			= vld_i;
			shift_multiplier #(
				.N(N)
			) dut (
				.a(a[i]),
				.b(b[i]),
				.vld(vld[i]),
				.c(c[i]),
				.result_vld(result_vld[i]),
				.*
			);
		end
	endgenerate
endmodule