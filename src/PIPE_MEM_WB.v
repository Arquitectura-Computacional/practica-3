module PIPE_MEM_WB
(
	input clk,
	input reset,
    input [31:0] read_data_w,
    input [31:0] mux_output_mem_to_reg_w,

    output reg [31:0] read_data_w_o,
    output reg [31:0] mux_output_mem_to_reg_w_o

);

always @(negedge reset or posedge clk)
    begin
		if (reset == 0)
			begin
                read_data_w_o <= 0;
                mux_output_mem_to_reg_w_o <= 0;
			end
		else
			begin
                read_data_w_o <= read_data_w;
                mux_output_mem_to_reg_w_o <= mux_output_mem_to_reg_w;
			end
	end

endmodule