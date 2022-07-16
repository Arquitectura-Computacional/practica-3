module PIPE_IF_ID
(
	input clk,
	input reset,
    input [31:0] instruction_w,
    input [31:0] pc_values,
    input [31:0] result_pc_plus_4_id,

    output reg [31:0] instruction_w_o,
    output reg [31:0] pc_values_o,
    output reg [31:0] result_pc_plus_4_id_o

);

always @(negedge reset or posedge clk)
    begin
        if (reset == 0)
            begin
                instruction_w_o <= 0;
                pc_values_o <= 0;
                result_pc_plus_4_o <= 0;
            end
        else
            begin
                instruction_w_o <= instruction_w;
                pc_values_o <= pc_values;
                result_pc_plus_4_o <= result_pc_plus_4;
            end
    end

endmodule