module PIPE_EX_MEM
(
	input clk,
	input reset,
    input [31:0] alu_result_w,
    input [31:0] mux_output_data_or_imm,
    input [31:0] result_pc_plus_4_mem,
    input [31:0] pc_plus_4_or_pc_jalr_ex,
    input mem_read_mem_w,
	input [1:0] mem_to_reg_mem_w,
	input mem_write_mem_w,
    input [31:0] read_data_2_mem_w,

    output reg [31:0] alu_result_w_o,
    output reg [31:0] mux_output_data_or_imm_o,
    output reg [31:0] result_pc_plus_4_mem_o,
    output reg [31:0] pc_plus_4_or_pc_jalr_ex_o,
    output reg mem_read_mem_w_o,
	output reg [1:0] mem_to_reg_mem_w_o,
	output reg mem_write_mem_w_o,
    output reg [31:0] read_data_2_mem_w_o
);

always @(negedge reset or posedge clk)
    begin
        if (reset == 0)
            begin
                alu_result_w_o <= 0;
                mux_output_data_or_imm_o <= 0;
                result_pc_plus_4_mem_o <= 0;
                pc_plus_4_or_pc_jalr_ex_o <= 0;
                mux_output_data_or_imm_o <= 0;
                mem_read_mem_w_o <= 0;
                mem_to_reg_mem_w_o <= 0;
                mem_write_mem_w_o <= 0;
                read_data_2_mem_w_o <= 0;
            end
        else
            begin
                alu_result_w_o <= alu_result_w;
                mux_output_data_or_imm_o <= mux_output_data_or_imm;
                result_pc_plus_4_mem_o <= result_pc_plus_4_mem;
                pc_plus_4_or_pc_jalr_ex_o <= pc_plus_4_or_pc_jalr_ex;
                mux_output_data_or_imm_o <= mux_output_data_or_imm;
                mem_read_mem_w_o <= mem_read_mem_w;
                mem_to_reg_mem_w_o <= mem_to_reg_mem_w;
                mem_write_mem_w_o <= mem_write_mem_w;
                read_data_2_mem_w_o <= read_data_2_mem_w_o;
            end
    end

endmodule