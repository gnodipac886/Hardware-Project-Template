module two_bit_multiplier_tb (
	input logic clk
);

	localparam N = 4;
	localparam a_N		= 16;
	/**************************** LOGIC DECLARATION ******************************/
	logic 						rst_n;
	logic 		[a_N-1:0]		a;
	logic 		[N-1:0]			b_i;
	logic 		[N-1:0]			b_j;
	logic 						one_term;
	logic 						b_sign;
	logic 						vld;
	logic 		[(a_N<<1)-1:0]	c;
	logic 						result_vld;

	/************************** CLOCKING DECLARATION *****************************/
	default clocking tb_clk @(posedge clk); endclocking

	/**************************** DUT DECLARATION ********************************/
	two_bit_multiplier3 #(
		.a_N(a_N),
		.N(N)
	) dut (
		.*
	);

	/***************************** FUNC DECLARATION ******************************/

	/***************************** TASK DECLARATION ******************************/
	task reset();
		rst_n 	<= 0;
		a		<= '0;
		b_i		<= '0;
		b_j		<= '0;
		b_sign  <= '0;
		one_term<= '0;
		vld		<= '0;

		##1;
		rst_n 	<= 1;

		##1;
	endtask

	task test(logic [15:0] a1, logic [N-1:0] b_i_1, logic [N-1:0] b_j_1, logic one_term_1, logic b_sign_1);
		int 	b = 0;
		if (one_term_1) begin 
			b = (1 << b_i_1);
		end else begin 
			b = b_sign_1 ? ((1 << b_i_1) - (1 << b_j_1)) : ((1 << b_i_1) + (1 << b_j_1));
		end

		a		<= a1;
		b_i		<= b_i_1;
		b_j		<= b_j_1;
		one_term<= one_term;
		b_sign  <= b_sign_1;

		vld		<= 1'b1;

		@(tb_clk iff result_vld);
		assert (c == a1 * b) //$display("✅ ANSWER IS CORRECT %d", c);
			else begin 
				$error("❌ ANSWER IS INCORRECT a: %d, b: %d, c: %d should be: %d", a, b, c, a1 * b);
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
		for (int a2 = 0; a2 < (1 << N) - 1; a2 ++) begin 
			for (int m2 = 0; m2 < (1 << N) - 1; m2 ++) begin 
				if ($countbits(m2, '1) <= 2) begin 
					$display("Multiplying for %d", m2);
					for (int m1 = 0; m1 < (1 << N) - 1; m1 ++) begin 
						for (int sign = 0; sign < 2; sign++) begin
							test(a2, m1, m2, 1'b0, sign);
							##1;

							// $display("➡️➡️➡️➡️➡️ a: %d, b: %d, result: %d", m1, m2, c);
							reset(); 
						end
					end 
				end 
			end 
		end

		##1;
	endtask

endmodule