module PIPE_ID_EX
(
	input clk,
	input reset,
	input [31:0] immediate_data_w,
	input [31:0] read_data_1_w,
	input [31:0] read_data_2_w,
	input [3:0] alu_operation_w,
	input [31:0] result_pc_plus_4_ex,
	input jalr_ex_w,
	input jal_ex_w,
	input branch_ex_w,
	input mem_read_ex_w,
	input [1:0] mem_to_reg_ex_w,
	input mem_write_ex_w,
	input alu_src_ex_w,

	output reg [31:0] immediate_data_w_o,
	output reg [31:0] read_data_1_w_o,
	output reg [31:0] read_data_2_w_o,
	output reg [3:0] alu_operation_w_o,
	output reg [3:0] result_pc_plus_4_ex_o,
	output reg jalr_ex_w_o,
	output reg jal_ex_w_o,
	output reg branch_ex_w_o,
	output reg mem_read_ex_w_o,
	output reg [1:0] mem_to_reg_ex_w_o,
	output reg mem_write_ex_w_o,
	output reg alu_src_ex_w_o
);

always @(negedge reset or posedge clk)
	begin
		if (reset == 0)
			begin
				immediate_data_w_o <= 0;
				read_data_1_w_o <= 0;
				read_data_2_w_o <= 0;
				alu_operation_w_o <= 0;
				result_pc_plus_4_ex_o <= 0;
				jalr_ex_w_o <= 0;
				jal_ex_w_o <= 0;
				branch_ex_w_o <= 0;
				mem_read_ex_w_o <= 0;
				mem_to_reg_ex_w_o <= 0;
				mem_write_ex_w <= 0;
				mem_write_ex_w_o <= 0;
			end
		else
			begin
				immediate_data_w_o <= immediate_data_w;
				read_data_1_w_o <= read_data_1_w;
				read_data_2_w_o <= read_data_2_w;
				alu_operation_w_o <= alu_operation_w;
				result_pc_plus_4_ex_o <= result_pc_plus_4_ex;
				jalr_ex_w_o <= jalr_ex_w_o;
				jal_ex_w_o <= jal_ex_w_o;
				branch_ex_w_o <= branch_ex_w_o;
				mem_read_ex_w_o <= mem_read_ex_w_o;
				mem_to_reg_ex_w_o <= mem_to_reg_ex_w_o;
				mem_write_ex_w <= mem_write_ex_w;
				mem_write_ex_w_o <= mem_write_ex_w_o;
			end
	end

endmodule