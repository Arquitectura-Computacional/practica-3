module PIPE_MEM_WB
(
	input clk,
	input reset,
    input [31:0] read_data_w,
    input [31:0] result_alu_w,
    input [31:0] result_pc_plus_4_wb,
    input [31:0] pc_plus_4_or_pc_jalr_ex,
	input [1:0] mem_to_reg_wb_w,

    output reg [31:0] read_data_w_o,
    output reg [31:0] result_alu_w_o,
    output reg [31:0] result_pc_plus_4_wb_o,
    output reg [31:0] pc_plus_4_or_pc_jalr_ex_o,
	output reg [1:0] mem_to_reg_wb_w_o

);

always @(negedge reset or posedge clk)
    begin
		if (reset == 0)
			begin
                read_data_w_o <= 0;
                mux_output_mem_to_reg_w_o <= 0;
                result_alu_w_o <= 0;
                result_pc_plus_4_wb_o <= 0;
                pc_plus_4_or_pc_jalr_ex_o <= 0;
                mem_to_reg_wb_w_o <= 0;
			end
		else
			begin
                read_data_w_o <= read_data_w;
                mux_output_mem_to_reg_w_o <= mux_output_mem_to_reg_w;
                result_alu_w_o <= result_alu_w;
                result_pc_plus_4_wb_o <= result_pc_plus_4_wb;
                pc_plus_4_or_pc_jalr_ex_o <= pc_plus_4_or_pc_jalr_ex;
                mem_to_reg_wb_w_o <= mem_to_reg_wb_w;
			end
	end

endmodule