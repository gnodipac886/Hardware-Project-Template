module template_tb (
	input logic clk
);

	localparam N = 4;
	/**************************** LOGIC DECLARATION ******************************/
	logic 						rst_n;
	logic 		[15:0]			a;
	logic 		[N-1:0]			b;
	logic 						vld;
	logic		[31:0] 			c;
	logic 						result_vld;

	/************************** CLOCKING DECLARATION *****************************/
	default clocking tb_clk @(posedge clk); endclocking

	/**************************** DUT DECLARATION ********************************/
	two_bit_multiplier #(
		.N(N)
	) dut (
		.*
	);

	/***************************** FUNC DECLARATION ******************************/
	function example_func;

	endfunction

	/***************************** TASK DECLARATION ******************************/
	task reset();
		rst_n 	<= 0;
		a		<= '0;
		b		<= '0;
		vld		<= '0;

		##1;
		rst_n 	<= 1;

		##1;
	endtask

	task test(logic [15:0] a1, logic [N-1:0] b1);
		a		<= a1;
		b		<= b1;
		vld		<= 1'b1;

		@(tb_clk iff result_vld);
		assert (c == a1 * b1) //$display("✅ ANSWER IS CORRECT %d", c);
			else begin 
				$error("❌ ANSWER IS INCORRECT a: %d, b: %d, c: %d", a, b, c);
				$finish;
			end

		##1;

		vld		<= 1'b0;

		// ##1;
	endtask

	task main();
		reset();

		##1;

		// test(4, 5);
		// $display("➡️➡️➡️➡️➡️ a: %d, b: %d, result: %d", 4, 5, c);

		for (int m2 = 0; m2 < (1 << N) - 1; m2 ++) begin 
			if ($countbits(m2, '1) <= 2) begin 
				$display("Multiplying for %d", m2);
				for (int m1 = 0; m1 < (1 << (16 + 1)) - 1; m1 ++) begin 
					test(m1, m2);
					##1;

					// $display("➡️➡️➡️➡️➡️ a: %d, b: %d, result: %d", m1, m2, c);
					reset();
				end 
			end 
		end 

		##1;
	endtask

endmodule