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
	logic 	[$clog2(N) - 1:0] 			first_one_bit_pos;
	logic	[1:0]						num_one_bits;

	assign 	num_one_bits 				= ^b ? 2'd1 : ((b == 0) ? 2'd0 : 2'd2);

	/**************************** TASK DECLARATION ******************************/
	// task reset();
		
	// endtask : reset

	/**************************** FUNC DECLARATION ******************************/
	function set_defaults;
		first_one_bit_pos 	= '0;
		c 					= '0;
		result_vld 			= '0;
	endfunction : set_defaults

	function void find_first_one_bit_pos();
		first_one_bit_pos 	= num_one_bits[0] ? $clog2(b) : ((b == 0) ? '0 : $clog2(b) - 1);
	endfunction : find_first_one_bit_pos

	function void multiply();
		c 					= (a << first_one_bit_pos) + ((num_one_bits == 2'd1) ? 0 : (a << $clog2(b & ~(1 << first_one_bit_pos))));
		// $display("first_one: %d, num_one_bits: %d, second_bit_pos: %d", first_one_bit_pos, num_one_bits, $clog2(b & ~(1 << first_one_bit_pos)));
	endfunction : multiply

	/******************************* COMB BLOCKS ********************************/
	always_comb begin : MULTIPLY
		set_defaults();
		if (vld) begin 
			if (b != '0) begin 
				find_first_one_bit_pos();
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