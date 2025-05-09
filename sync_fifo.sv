// Kaelyn Cho
// lab 7: asynchronous fifo
// https://vlsiverify.com/verilog/verilog-codes/synchronous-fifo/

module sync_fifo #(parameter DATA_WIDTH=8, parameter DEPTH=16) (
    input   logic   clk,
    input   logic   rst_,
    input   logic   w_en,
    input   logic   r_en,
    input   logic   [DATA_WIDTH-1:0]  wr_data,
    output  logic   [DATA_WIDTH-1:0]  rd_data,
    output  logic   full,
    output  logic   empty
);

    reg [$clog2(DEPTH)-1:0] tail, head;
    reg [DATA_WIDTH-1:0] fifo[DEPTH];  // memory array

    assign full = ((tail + 1) % DEPTH == head);
    assign empty = (tail == head);

    // Main logic for tail, head, and FIFO operations
    always @(posedge clk) begin
        if (!rst_) begin
            tail <= 0;
            head <= 0;
            rd_data <= 0;
        end else begin
            // Write data to FIFO
            if (w_en && !full) begin
                fifo[tail] <= wr_data;
                tail <= (tail + 1) % DEPTH;
            end

            // Read data from FIFO
            if (r_en && !empty) begin
                rd_data <= fifo[head];
                head <= (head + 1) % DEPTH;
            end
        end
    end

endmodule

//// Model Sim Code
//
//`timescale 1ns/100ps
//
//module sync_fifo #(parameter DATA_WIDTH=8) (
//    input   logic   clk,
//    input   logic   rst_,
//    input   logic   w_en,
//    input   logic   r_en,
//    input   logic   [DATA_WIDTH-1:0]  wr_data,
//    output  logic   [DATA_WIDTH-1:0]  rd_data,
//    output   logic   full,
//    output   logic   empty
//);
//
//    // $clog2() function calculates the ceiling of the log base 2 of DATA_WIDTH
//    // giving the minimum number of bits needed to represent 0 -> DATA_WIDTH-1
//    // write from tail, read from head (act as registers to wr_data/rd_data)
//    reg [$clog2(DATA_WIDTH)-1:0] tail, head;
//    reg [DATA_WIDTH-1:0] fifo[DATA_WIDTH];  // memory array
//    
//    assign full = ((tail+1'b1) == tail);
//    assign empty = (tail == head);
//
//    // default on reset
//    always@(posedge clk) begin
//        if (!rst_) begin
//            tail <= 0;
//            head <= 0;
//            rd_data <= 0;
//        end
//    end
//
//    // To write data to FIFO
//    always@(posedge clk) begin
//        if(w_en & !full)begin
//            fifo[tail] <= wr_data;
//            tail <= tail + 1;
//        end
//    end
//    
//    // To read data from FIFO
//    always@(posedge clk) begin
//        if(r_en & !empty) begin
//            rd_data <= fifo[head];
//            head <= head + 1;
//        end
//    end
//
//endmodule


