module shift_multiplier #(
	parameter a_N		= 16,
	parameter N 		= 4
)(
	input 	logic 									clk,
	input 	logic 									rst_n,
	input 	logic 		[a_N-1:0]					a,
	input 	logic 		[N-1:0]						b,
	input	logic 									vld,
	output	logic 		[(a_N + (1 << N))-1:0]		c,
	output 	logic 									result_vld
);

	/**************************** ENUM DECLARATION ******************************/
	enum logic [1:0] {
		IDLE, MUL, RESULT
	} state, next_state;

	/**************************** LOGIC DECLARATION *****************************/
	logic 	[$clog2(N) - 1:0] 			bit_counter;

	/**************************** TASK DECLARATION ******************************/
	task reset();
		state 		<= IDLE;
		bit_counter <= '0;
		c 			<= '0;
	endtask : reset

	task accumulate();
		if (state == MUL && vld) begin
			c 			<= b[bit_counter] ? c + (a << bit_counter) : c;
			bit_counter	<= bit_counter + 1;
		end 
	endtask

	/**************************** FUNC DECLARATION ******************************/
	function void set_state_defaults();
		next_state = state;
		result_vld = '0;
	endfunction : set_state_defaults

	function void set_action_defaults();
		unique case(state)
			IDLE: begin 
				if (vld)
					next_state = MUL;
			end 

			MUL: begin 
				if (bit_counter == N - 1)
					next_state = RESULT;
			end 

			RESULT: begin 
				result_vld = 1'b1;
				next_state = IDLE;
			end 

			default:;
		endcase
	endfunction : set_action_defaults

	/******************************* COMB BLOCKS ********************************/
	always_comb begin : NEXT_STATE_LOGIC
		set_state_defaults();
		set_action_defaults();
	end

	/******************************* PROC BLOCKS ********************************/
	always_ff @(posedge clk) begin
		if(~rst_n) begin
			reset();
		end else begin
			state <= next_state;
            accumulate();
		end
	end

endmodule