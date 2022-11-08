module two_bit_multiplier2 #(
	parameter N 		= 4
) (
	input 	logic 						clk,
	input 	logic 						rst_n,
	input 	logic 		[15:0]			a,
	input 	logic 		[N-1:0]			b,
	input	logic 						vld,
	output	logic 		[31:0]			c,
	output 	logic 						result_vld
);

	/**************************** ENUM DECLARATION ******************************/

	/**************************** LOGIC DECLARATION *****************************/
	logic [$clog2(N):0] 	first_one, second_one;
	logic [N-1:0]       	b_reverse;
	logic 					num_one_bits;

	logic [31:0]			first_shifted, second_shifted;

	assign first_one		= find_first_one_bit_pos(b);
	assign second_one   	= N - 1 - find_first_one_bit_pos(b_reverse);
	assign num_one_bits 	= ^b;

	assign first_shifted	= a << first_one;
	assign second_shifted	= a << second_one;

	/*************************** GENERATE DECLARATION ***************************/

	/**************************** TASK DECLARATION ******************************/

	/**************************** FUNC DECLARATION ******************************/
	function logic [$clog2(N):0] find_first_one_bit_pos(logic [N-1:0] local_b);
		priority case(1'b1)
			local_b[3]: begin
				return 3; 
			end 

			local_b[2]: begin
				return 2; 
			end 

			local_b[1]: begin
				return 1; 
			end 

			local_b[0]: begin
				return 0; 
			end 

			default:;
		endcase
	endfunction

	/******************************* COMB BLOCKS ********************************/
	always_comb begin
		for (logic [$clog2(N):0] i = 0; i < N; i++) begin 
			b_reverse[i] = b[N-i-1];
		end 
	end
	
	always_comb begin : MULTIPLY
		c 						= '0;
		result_vld 				= '0;
		if (vld) begin 
			if (b != '0) begin
				c 				= first_shifted + (num_one_bits ? 0 : second_shifted);
				// $display("%d, %d, %d", a, b, c);
			end
			result_vld = 1'b1;
		end
	end

	/******************************* PROC BLOCKS ********************************/

endmodule