module template #(
	parameter TEMPLATE 		= 512
)(
	input 	logic 						clk_i,
	input 	logic 						rst_n,
);

	/**************************** ENUM DECLARATION ******************************/
	enum logic [1:0] {
		A, B, C
	} state, next_state;

	/**************************** LOGIC DECLARATION *****************************/

	/**************************** TASK DECLARATION ******************************/
	task reset();

	endtask : reset

	/**************************** FUNC DECLARATION ******************************/
	function void set_state_defaults();

	endfunction : set_state_defaults

	function void set_action_defaults();
        
	endfunction : set_action_defaults

	/******************************* COMB BLOCKS ********************************/
	always_comb begin : NEXT_STATE_LOGIC
		set_state_defaults();
		set_action_defaults();
	end

	/******************************* PROC BLOCKS ********************************/
	always_ff @(posedge clk_i) begin
		if(~rst_n) begin
			reset();
		end else begin
            
		end
	end

endmodule