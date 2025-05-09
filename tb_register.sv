`timescale 1ns/100ps

module tb_register;

    logic       rst_  = 1'b1;
    logic       clk   = 1'b1;
    logic       enable;
    logic [7:0] out;
    logic [7:0] data;

    `define PERIOD 10

    always begin
        #(`PERIOD/2) clk = ~clk;
    end

    // INSTANCE register 
    register #(.DATA_WIDTH (8)) dut_register(
        .clk  (clk      ),
        .rst_ (rst_     ),
        .en   (enable   ),
        .data (data     ),
        .out  (out      )
    );    
	
	 // Assertions for verification
    property p_reset_behavior;
        @(posedge clk) disable iff (!rst_) out == 'b0;
    endproperty

    assert property (p_reset_behavior)
        else $fatal("Reset behavior failed: output should be zero when reset is asserted");

    property p_enable_behavior;
        @(posedge clk) (rst_ && enable) |-> (out == data);
    endproperty

    assert property (p_enable_behavior)
        else $fatal("Enable behavior failed: output should follow data when enable is asserted");

    property p_disable_behavior;
        @(posedge clk) (rst_ && !enable) |-> (out == $past(out));
    endproperty

    assert property (p_disable_behavior)
        else $fatal("Disable behavior failed: output should retain its value when enable is deasserted");
    // Monitor Results
    initial begin
        $timeformat(-9, 1, " ns", 9);
        $monitor ("time=%t enable=%b rst_=%b data=%h out=%h", $time,enable,rst_,data,out);
        #(`PERIOD * 99)
        $display ( "REGISTER TEST TIMEOUT" );
        $finish;
    end

    // Verify Results
    task expect_test (input [7:0] expects) ;
        if ( out !== expects ) begin
            $display ( "out=%b, should be %b", out, expects );
            $display ( "REGISTER TEST FAILED" );
            $finish;
        end
    endtask

    initial begin
        @(negedge clk)
        { rst_, enable, data } = 10'b1_X_XXXXXXXX; @(negedge clk) expect_test ( 8'hXX );
        { rst_, enable, data } = 10'b0_X_XXXXXXXX; @(negedge clk) expect_test ( 8'h00 );
        { rst_, enable, data } = 10'b1_0_XXXXXXXX; @(negedge clk) expect_test ( 8'h00 );
        { rst_, enable, data } = 10'b1_1_10101010; @(negedge clk) expect_test ( 8'hAA );
        { rst_, enable, data } = 10'b1_0_01010101; @(negedge clk) expect_test ( 8'hAA );
        { rst_, enable, data } = 10'b0_X_XXXXXXXX; @(negedge clk) expect_test ( 8'h00 );
        { rst_, enable, data } = 10'b1_0_XXXXXXXX; @(negedge clk) expect_test ( 8'h00 );
        { rst_, enable, data } = 10'b1_1_01010101; @(negedge clk) expect_test ( 8'h55 );
        { rst_, enable, data } = 10'b1_0_10101010; @(negedge clk) expect_test ( 8'h55 );
        $display ( "REGISTER TEST PASSED" );
        $finish;
    end

endmodule
