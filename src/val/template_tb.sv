module template_tb(
	input logic clk
);
	/**************************** LOGIC DECLARATION ******************************/
	logic    [7:0]  template;

	/************************** CLOCKING DECLARATION *****************************/
	default clocking tb_clk @(posedge clk); endclocking

	/**************************** DUT DECLARATION ********************************/
	TEMPLATE dut (
		.clock(clk),
		.*
	);

	/***************************** FUNC DECLARATION ******************************/
	function example_func;

	endfunction

	/***************************** TASK DECLARATION ******************************/
	task reset();

	endtask

	task test(logic [7:0] a, logic [7:0] b, logic [7:0] c);

	endtask

	task main();
		reset();

		##1;

		test(5, 5, 0);
		##1;

		$display("➡️➡️➡️➡️➡️ template: %d");
		reset();

		##1;
	endtask

endmodule