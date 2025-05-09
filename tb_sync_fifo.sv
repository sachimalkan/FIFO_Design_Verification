// Kaelyn Cho
// lab 7: asynchronous fifo
// https://vlsiverify.com/verilog/verilog-codes/synchronous-fifo/

`timescale 1ns/100ps
module tb_sync_fifo;
  parameter DATA_WIDTH = 8;
  
  reg clk, rst_n;
  reg w_en, r_en;
  reg [DATA_WIDTH-1:0] wr_data;
  wire [DATA_WIDTH-1:0] rd_data;
  wire full, empty;
  
  // Queue to push wr_data
  reg [DATA_WIDTH-1:0] wdata_q[$], wdata;

  sync_fifo s_fifo(clk, rst_n, w_en, r_en, wr_data, rd_data, full, empty);

  always #5ns clk = ~clk;
  
  initial begin
    clk = 1'b0; rst_n = 1'b0;
    w_en = 1'b0;
    wr_data = 0;
    
    repeat(10) @(posedge clk);
    rst_n = 1'b1;

    repeat(2) begin
      for (int i=0; i<30; i++) begin
        @(posedge clk);
        w_en = (i%2 == 0)? 1'b1 : 1'b0;
        if (w_en & !full) begin
          wr_data = $urandom;
          wdata_q.push_back(wr_data);
        end
      end
      #50;
    end
  end

  initial begin
    clk = 1'b0; rst_n = 1'b0;
    r_en = 1'b0;

    repeat(20) @(posedge clk);
    rst_n = 1'b1;

    repeat(2) begin
      for (int i=0; i<30; i++) begin
        @(posedge clk);
        r_en = (i%2 == 0)? 1'b1 : 1'b0;
        if (r_en & !empty) begin
          #1;
          wdata = wdata_q.pop_front();
          if(rd_data !== wdata) $error("Time = %0t: Comparison Failed: expected wr_data = %h, rd_data = %h", $time, wdata, rd_data);
          else $display("Time = %0t: Comparison Passed: wr_data = %h and rd_data = %h",$time, wdata, rd_data);
        end
      end
      #50;
    end

    $finish;
  end
  
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule