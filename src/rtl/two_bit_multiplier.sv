module two_bit_multiplier #(
	parameter N 		= 4
) (
	input 	logic 						clk,
	input 	logic 						rst_n,
	input 	logic 		[15:0]			a,
	input 	logic 		[N-1:0]			b,
	input	logic 						vld,
	output	logic 		[31:0]          c,
	output 	logic 						result_vld
);

	/**************************** ENUM DECLARATION ******************************/

	/**************************** LOGIC DECLARATION *****************************/
	// logic 	[$clog2(N) - 1:0] 			first_one_bit_pos;
	// logic	[1:0]						num_one_bits;

	// assign 	num_one_bits 				= ^b ? 2'd1 : ((b == 0) ? 2'd0 : 2'd2);
	// assign 	first_one_bit_pos 			= find_first_one_bit_pos(b);

	/**************************** TASK DECLARATION ******************************/

	/**************************** FUNC DECLARATION ******************************/
	// function set_defaults();
	// 	c 					= '0;
	// 	result_vld 			= '0;
	// endfunction : set_defaults

	// function int find_first_one_bit_pos(int local_b);
	// 	int pos 	= 0;
	// 	for (int i = 0; i < N;  i++) begin 
	// 		if (local_b[i])
	// 			pos 	= i;
	// 	end 
	// 	return pos;
	// endfunction : find_first_one_bit_pos

	function void multiply();
		// c 					= (a << first_one_bit_pos) + ((num_one_bits == 2'd1) ? 0 : (a << find_first_one_bit_pos(b & ~(1 << first_one_bit_pos))));
		// $display("first_one: %d, num_one_bits: %d, second_bit_pos: %d", first_one_bit_pos, num_one_bits, $clog2(b & ~(1 << first_one_bit_pos)));
		int first_term = 0;
		int second_term = 0;
		logic found_one = 1'b0;
		for (int i = 0; i < N; i++) begin 
			if (b[i]) begin 
				first_term = a << i;
				for (int j = N - 1; j > i; j--) begin 
					if (b[j] && j < N) begin 
						second_term = a << j;
						// if (b == 4)
						// 	$display("%d", j);
					end 
				end 
				break;
			end 
		end 
		c = first_term + second_term;
		// $display("%d, %d, %d, %d, %d", a, b, c, first_term, second_term);
	endfunction : multiply

	/******************************* COMB BLOCKS ********************************/
	always_comb begin : MULTIPLY
		c 						= '0;
		result_vld 				= '0;
		if (vld) begin 
			if (b != '0 && a != '0) begin
				multiply();
			end
			result_vld = 1'b1;
		end
	end

	/******************************* PROC BLOCKS ********************************/
	// always_ff @(posedge clk_i) begin
	// 	if(~rst_n) begin
	// 		reset();
	// 	end else begin
			
	// 	end
	// end

endmodule
