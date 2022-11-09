module two_bit_multiplier3 #(
	parameter a_N		= 4,
	parameter N 		= 3
) (
	input 	logic 								clk,
	input 	logic 								rst_n,
	input 	logic 		[a_N-1:0]				a,
	input 	logic 		[N-1:0]					b_i,
	input 	logic 		[N-1:0]					b_j,
	input 	logic 								one_term,
	input 	logic 								b_sign,
	input	logic 								vld,
	output	logic 		[(a_N + (1 << N))-1:0]	c,
	output 	logic 								result_vld
);

	/**************************** ENUM DECLARATION ******************************/
	

	/**************************** LOGIC DECLARATION *****************************/
	logic [(a_N + (1 << N))-1:0] 	two_term_result;
	
	assign 							result_vld 		= vld;
	assign 							two_term_result = (a << b_i) + (b_sign ? ((-a) << b_j): (a << b_j));
	assign 							c 				= one_term ? (a << b_i) : two_term_result;

	/*************************** GENERATE DECLARATION ***************************/


	/**************************** TASK DECLARATION ******************************/


	/**************************** FUNC DECLARATION ******************************/
	

	/******************************* COMB BLOCKS ********************************/
	// always_comb begin
	// 	if (vld)
	// 		$display("a: %d, b_i: %d, b_j: %d, one_term: %d, b_sign: %d, plus: %d, minus: %d", a, b_i, b_j, one_term, b_sign, plus_result, minus_result);
	// end

	/******************************* PROC BLOCKS ********************************/
	

endmodule