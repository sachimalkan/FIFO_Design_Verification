`timescale 1ns/100ps

module register #(parameter DATA_WIDTH = 8) (
    input wire clk,
    input wire rst_,  // Active-low reset
    input wire en,
    input wire [DATA_WIDTH-1:0] data,
    output reg [DATA_WIDTH-1:0] out
);

always @(posedge clk or negedge rst_) begin
    if (!rst_) begin
        out <= 'b0;  // Reset the output when reset is low
    end
    else if (en) begin
        out <= data;  // Load data when enabled
    end
end

endmodule
