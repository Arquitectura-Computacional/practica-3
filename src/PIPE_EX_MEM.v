module PIPE_EX_MEM
(
	input clk,
	input reset,
    input [31:0] alu_result_w,
    input [31:0] mux_output_data_or_imm,
    input result_or_branch_alu,
    input result_and_branch_alu,
    input [31:0] mux_output_pc_branch,
    input [31:0] mux_output_pc_jal,
    input [31:0] mux_output_pc_jalr,

    output reg [31:0] alu_result_w_o,
    output reg [31:0] mux_output_data_or_imm_o,
    output reg result_or_branch_alu_o,
    output reg result_and_branch_alu_o,
    output reg [31:0] mux_output_pc_branch_o,
    output reg [31:0] mux_output_pc_jal_o,
    output reg [31:0] mux_output_pc_jalr_o

);

always @(negedge reset or posedge clk)
    begin
        if (reset == 0)
            begin
                alu_result_w_o <= 0;
                mux_output_data_or_imm_o <= 0;
                result_or_branch_alu_o <= 0;
                result_and_branch_alu_o <= 0;
                mux_output_pc_branch_o <= 0;
                mux_output_pc_jal_o <= 0;
                mux_output_pc_jalr_o <= 0;
            end
        else
            begin
                alu_result_w_o <= alu_result_w;
                mux_output_data_or_imm_o <= mux_output_data_or_imm;
                result_or_branch_alu_o <= result_or_branch_alu;
                result_and_branch_alu_o <= result_and_branch_alu;
                mux_output_pc_branch_o <= mux_output_pc_branch;
                mux_output_pc_jal_o <= mux_output_pc_jal;
                mux_output_pc_jalr_o <= mux_output_pc_jalr;
            end
    end

endmodule