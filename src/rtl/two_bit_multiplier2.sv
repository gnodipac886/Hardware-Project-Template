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
	enum logic [1:0] {
		IDLE, MUL, RESULT
	} state, next_state;

	/**************************** LOGIC DECLARATION *****************************/
	// logic [$clog2(N):0] 	first_one, second_one;
	logic [N-1:0]       	b_reverse;
	logic 					num_one_bits;

	// logic [31:0]			first_shifted, second_shifted;

	// assign first_one		= find_first_one_bit_pos(b);
	// assign second_one   	= N - 1 - find_first_one_bit_pos(b_reverse);
	assign num_one_bits 	= ^b;

	// assign first_shifted	= a << first_one;
	// assign second_shifted	= a << second_one;

	/*************************** GENERATE DECLARATION ***************************/

	/**************************** TASK DECLARATION ******************************/
	task reset();
		state 		<= IDLE;
	endtask : reset

	/**************************** FUNC DECLARATION ******************************/
	function logic [$clog2(N):0] find_first_one_bit_pos(logic [N-1:0] local_b);
		// logic [$clog2(N):0] temp = 0;
		// for (int i = 0; i < N; i++) begin 
		// 	temp = local_b[i] ? i : temp; 
		// end 
		// return temp;
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
		result_vld 				= '0;
		next_state = state;
		unique case(state)
			IDLE: begin 
				if (vld) begin
					next_state 	= MUL;
				end
			end 

			MUL: begin 
				next_state 		= RESULT;
			end 

			RESULT: begin 
				next_state		= IDLE;
				result_vld		= 1'b1;
			end 
		endcase
	end

	/******************************* PROC BLOCKS ********************************/
	always_ff @(posedge clk) begin
		if(~rst_n) begin
			reset();
		end else begin
			state <= next_state;
			unique case(state)
				IDLE: begin 
					if (vld) begin
						c 			<= a << find_first_one_bit_pos(b);
					end
				end 

				MUL: begin 
					c 				<= b == 0 ? '0 : (c + (num_one_bits ? 0 : a << (N - 1 - find_first_one_bit_pos(b_reverse))));
				end 

				RESULT: begin
					c  				<= '0;
				end 
			endcase
		end
	end

endmodule