/******************************************************************
* Description
*	This is the top-level of a RISC-V Microprocessor that can execute the next set of instructions:
*		add
*		addi
* This processor is written Verilog-HDL. It is synthesizabled into hardware.
* Parameter MEMORY_DEPTH configures the program memory to allocate the program to
* be executed. If the size of the program changes, thus, MEMORY_DEPTH must change.
* This processor was made for computer organization class at ITESO.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	16/08/2021
******************************************************************/

module RISC_V_Single_Cycle
#(
	parameter PROGRAM_MEMORY_DEPTH = 64,  //64
	parameter DATA_MEMORY_DEPTH = 256,	//128
	parameter DATA_MEMORY_WIDTH = 32
)

(
	// Input
	input clk,
	input reset,
	
	output [31:0] ALU_Exit_o
);
//******************************************************************/
//******************************************************************/

//******************************************************************/
//******************************************************************/
/* Signals to connect modules*/

/**Control**/
wire jal_o_w;
wire jalr_o_w;
wire branch_o_w;
wire alu_src_w;
wire reg_write_w;
wire [1:0] mem_to_reg_w;
wire mem_write_w;
wire mem_read_w;
wire [2:0] alu_op_w;

/** Program Counter**/
wire [31:0] pc_plus_4_w;
wire [31:0] pc_w;

/**Data Memory**/
wire [31:0] read_data_w;

/**Adder**/
wire [31:0] pc_plus_immediate_w;

/**Register File**/
wire [31:0] read_data_1_w;
wire [31:0] read_data_2_w;
wire [31:0] write_data_w;

/**immmediate Unit**/
wire [31:0] immmediate_data_w;

/**Multiplexer MUX_PC_JAL**/

wire [31:0]  pc_plus_4_or_pc_jal;

/**Multiplexer MUX_PC_JALR**/

wire [31:0] pc_plus_4_or_pc_jalr;

/**ALU**/
wire [31:0] alu_result_w;

/**Multiplexer MUX_DATA_OR_IMM_FOR_ALU**/
wire [31:0] read_data_2_or_imm_w;

/**Multiplexer MUX_PC_BRANCH**/
wire [31:0] pc_plus_4_or_pc_plus_imm_w;

/**ALU Control**/
wire [3:0] alu_operation_w;

/**Instruction Bus**/	
wire [31:0] instruction_bus_w;

//MUX Mem To Reg
//wire [31:0]Output_mem_to_reg_w;

//wire [31:0]Output_Mux_Memtoreg_w;

/**And Module**/
wire pc_src_w;
wire OR_Module;

/** Pipeline IF -> ID **/
wire [31:0] pipe_if_id_instruction_w;
wire [31:0] pipe_if_id_pc_w;
wire [31:0] pipe_if_id_pc_plus_immediate_w;

/** Pipeline ID -> EX **/
wire [31:0] pipe_id_ex_immediate_data_w_o;
wire [31:0] pipe_id_ex_read_data_1_w_o;
wire [31:0] pipe_id_ex_read_data_2_w_o;
wire [31:0] pipe_id_ex_alu_operation_w_o;
wire [31:0] pipe_id_ex_pc_plus_4_w;
wire pipe_id_ex_jalr_ex_w_o;
wire pipe_id_ex_jal_ex_w_o;
wire pipe_id_ex_branch_ex_w_o;
wire pipe_id_ex_mem_read_ex_w_o;
wire pipe_id_ex_mem_write_ex_w_o;
wire pipe_id_ex_alu_src_ex_w_o;
wire [1:0] pipe_id_ex_mem_to_reg_ex_w_o;

/** Pipeline EX -> MEM **/
wire [31:0] pipe_ex_mem_alu_result_w_o;
wire [31:0] pipe_ex_mem_result_or_branch_alu_o;
wire [31:0] pipe_ex_mem_result_and_branch_alu_o;
wire [31:0] pipe_ex_mem_mux_output_data_or_imm_o;
wire [31:0] pipe_ex_mem_mux_output_pc_branch_o;
wire [31:0] pipe_ex_mem_mux_output_pc_jal_o;
wire [31:0] pipe_ex_mem_mux_output_pc_jalr_o;

wire [31:0] pipe_ex_mem_pc_plus_4_w;
wire [31:0] pc_plus_4_or_pc_jalr_ex_w_o;
wire pipe_ex_mem_mem_read_mem_w_o;
wire [1:0] pipe_ex_mem_mem_to_reg_mem_w_o;
wire pipe_ex_mem_mem_write_mem_w_o;
wire pipe_ex_mem_read_data_2_w_o;

/** Pipeline MEM -> WB **/
wire [31:0] pipe_mem_mux_Data_w;
wire [31:0] pipe_mem_wb_alu_result_w_o;
wire [31:0] pipe_mem_wb_pc_plus_4_w_o;
wire [31:0] pc_plus_4_or_pc_jalr_wb_w_o;
wire [1:0] pipe_mem_wb_mem_to_reg_wb_w_o;

//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
Control
CONTROL_UNIT
(
	/****/
	.OP_i(pipe_if_id_instruction_w[6:0]),
	/** outputus**/
	.Jalr_o(jalr_o_w),
	.Jal_o(jal_o_w),
	.Branch_o(branch_o_w),
	.ALU_Op_o(alu_op_w),
	.ALU_Src_o(alu_src_w),
	.Reg_Write_o(reg_write_w),
	.Mem_to_Reg_o(mem_to_reg_w),
	.Mem_Read_o(mem_read_w),
	.Mem_Write_o(mem_write_w)
);

PC_Register
PROGRAM_COUNTER
(
	.clk(clk),
	.reset(reset),
	.Next_PC(pc_plus_4_or_pc_jalr_wb_w_o),
	.PC_Value(pc_w)
);

Program_Memory
#(
	.MEMORY_DEPTH(PROGRAM_MEMORY_DEPTH)
)
PROGRAM_MEMORY
(
	.Address_i(pipe_if_id_pc_w),
	.Instruction_o(instruction_bus_w)
);

Data_Memory
#(
	.MEMORY_DEPTH(DATA_MEMORY_DEPTH),
	.DATA_WIDTH(DATA_MEMORY_WIDTH)
)
DATA_MEMORY
(	
	.clk(clk),
	.Mem_Write_i(pipe_ex_mem_mem_write_mem_w_o),
	.Mem_Read_i(pipe_ex_mem_mem_read_mem_w_o),
	.Write_Data_i(pipe_id_ex_read_data_2_w_o),
	.Address_i(pipe_ex_mem_read_data_2_w_o),
	
	.Read_Data_o(read_data_w)
);

Adder_32_Bits
PC_PLUS_4
(
	.Data0(pc_w),
	.Data1(4),
	.Result(pc_plus_4_w)
);

Adder_32_Bits
PC_PLUS_IMMEDIATE
(
	.Data0(pipe_id_ex_pc_plus_4_w),
	.Data1(pipe_id_ex_immediate_data_w_o),
	.Result(pc_plus_immediate_w)
);


//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/


Register_File
REGISTER_FILE_UNIT
(
	.clk(clk),
	.reset(reset),
	.Reg_Write_i(reg_write_w),
	.Write_Register_i(pipe_if_id_instruction_w[11:7]),
	.Read_Register_1_i(pipe_if_id_instruction_w[19:15]),
	.Read_Register_2_i(pipe_if_id_instruction_w[24:20]),
	.Write_Data_i(write_data_w),

	.Read_Data_1_o(read_data_1_w),
	.Read_Data_2_o(read_data_2_w)
);

Immediate_Unit
IMM_UNIT
(  .op_i(pipe_if_id_instruction_w[6:0]),
   .Instruction_bus_i(pipe_if_id_instruction_w),
   .Immediate_o(immmediate_data_w) 
);

Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_DATA_OR_IMM_FOR_ALU
(
	.Selector_i(pipe_id_ex_alu_src_ex_w_o),
	.Mux_Data_0_i(pipe_id_ex_read_data_2_w_o),
	.Mux_Data_1_i(pipe_id_ex_immediate_data_w_o),
	
	.Mux_Output_o(read_data_2_or_imm_w) //pipe_ex_mem_mux_output_data_or_imm_o

);

Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_PC_BRANCH
(
	.Selector_i(pc_src_w),    //pc_src_w del and
	.Mux_Data_0_i(pipe_id_ex_pc_plus_4_w),
	.Mux_Data_1_i(pc_plus_immediate_w),
	
	.Mux_Output_o(pc_plus_4_or_pc_plus_imm_w)

);

Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_PC_JAL
(
	.Selector_i(pipe_id_ex_jal_ex_w_o),
	.Mux_Data_0_i(pc_plus_4_or_pc_plus_imm_w),
	.Mux_Data_1_i(pc_plus_immediate_w),
	
	.Mux_Output_o(pc_plus_4_or_pc_jal)

);

Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_PC_JALR
(
	.Selector_i(jalr_o_w),
	.Mux_Data_0_i(pc_plus_4_or_pc_jal),
	.Mux_Data_1_i(alu_result_w),
	
	.Mux_Output_o(pc_plus_4_or_pc_jalr)

);

And_Module
AND_BRANCH_ALU
(
    .A_i(pipe_id_ex_branch_ex_w_o),
    .B_i(alu_result_w),
    .result(pc_src_w)
);

ALU_Control
ALU_CONTROL_UNIT
(
	.funct7_i(pipe_if_id_instruction_w[30]),
	.ALU_Op_i(alu_op_w),
	.funct3_i(pipe_if_id_instruction_w[14:12]),

	.ALU_Operation_o(alu_operation_w)

);

ALU
ALU_UNIT
(
	.ALU_Operation_i(pipe_id_ex_alu_operation_w_o),
	.A_i(pipe_id_ex_read_data_1_w_o),
	.B_i(read_data_2_or_imm_w),
	.pc_plus_4(pipe_id_ex_pc_plus_4_w),

	.ALU_Result_o(alu_result_w)
);

Multiplexer_4_to_1
#(
	.NBits(32)
)
MUX_MEM_TO_REG
(
	.Selector_i(mem_to_reg_w),
	.Mux_Data_0_i(pipe_mem_wb_alu_result_w_o),
	.Mux_Data_1_i(pipe_mem_mux_Data_w),
	.Mux_Data_2_i(pipe_mem_wb_pc_plus_4_w_o),


	.Mux_Output_o(write_data_w)

);

assign ALU_Exit_o = pipe_ex_mem_alu_result_w_o;

//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/

//azul
PIPE_IF_ID
IF_ID
(
	.clk(clk),
	.reset(reset),
	.instruction_w(instruction_bus_w),
	.result_pc_plus_4_id(pc_plus_4_w),
	.pc_values(pc_w),

	.instruction_w_o(pipe_if_id_instruction_w),
	.pc_values_o(pipe_if_id_pc_w),
	.result_pc_plus_4_id_o(pipe_if_id_pc_plus_4_w)
);

//rojo
PIPE_ID_EX
ID_EX
(
	.clk(clk),
	.reset(reset),
	.immediate_data_w(immmediate_data_w), //immediate unit
	.read_data_1_w(read_data_1_w),
	.read_data_2_w(read_data_2_w),
	.alu_operation_w(alu_operation_w),
	.result_pc_plus_4_ex(pipe_if_id_pc_plus_4_w),
	.jalr_ex_w(jalr_o_w),
	.jal_ex_w(jal_o_w),
	.branch_ex_w(branch_o_w),
	.mem_read_ex_w(mem_read_w),
	.mem_to_reg_ex_w(mem_to_reg_w),
	.mem_write_ex_w(mem_write_w),
	.alu_src_ex_w(alu_src_w),

	.immediate_data_w_o(pipe_id_ex_immediate_data_w_o),
	.read_data_1_w_o(pipe_id_ex_read_data_1_w_o),
	.read_data_2_w_o(pipe_id_ex_read_data_2_w_o),
	.alu_operation_w_o(pipe_id_ex_alu_operation_w_o),
	.result_pc_plus_4_ex_o(pipe_id_ex_pc_plus_4_w),
	.jalr_ex_w_o(pipe_id_ex_jalr_ex_w_o),
	.jal_ex_w_o(pipe_id_ex_jal_ex_w_o),
	.branch_ex_w_o(pipe_id_ex_branch_ex_w_o),
	.mem_read_ex_w_o(pipe_id_ex_mem_read_ex_w_o),
	.mem_to_reg_ex_w_o(pipe_id_ex_mem_to_reg_ex_w_o),
	.mem_write_ex_w_o(pipe_id_ex_mem_write_ex_w_o),
	.alu_src_ex_w_o(pipe_id_ex_alu_src_ex_w_o)

);

//amarillo
PIPE_EX_MEM
EX_MEM
(
	.clk(clk),
	.reset(reset),
	.alu_result_w(alu_result_w),
	.mux_output_data_or_imm(read_data_2_or_imm_w),
   .result_pc_plus_4_mem(pipe_id_ex_pc_plus_4_w),
   .pc_plus_4_or_pc_jalr_ex(pc_plus_4_or_pc_jalr_ex_w),
   	.mem_read_mem_w(pipe_id_ex_mem_read_ex_w_o),
	.mem_to_reg_mem_w(pipe_id_ex_mem_to_reg_ex_w_o),
	.mem_write_mem_w(pipe_id_ex_mem_write_ex_w_o),
	.read_data_2_mem_w(pipe_id_ex_read_data_2_w_o),

   .alu_result_w_o(pipe_ex_mem_alu_result_w_o),
   .mux_output_data_or_imm_o(pipe_ex_mem_mux_output_data_or_imm_o),
   .result_pc_plus_4_mem_o(pipe_ex_mem_pc_plus_4_w),
   .pc_plus_4_or_pc_jalr_ex_o(pc_plus_4_or_pc_jalr_ex_w_o),
   	.mem_read_mem_w_o(pipe_ex_mem_mem_read_mem_w_o),
	.mem_to_reg_mem_w_o(pipe_ex_mem_mem_to_reg_mem_w_o),
	.mem_write_mem_w_o(pipe_ex_mem_mem_write_mem_w_o),
	.read_data_2_mem_w_o(pipe_ex_mem_read_data_2_w_o),
);

//negro
PIPE_MEM_WB
MEM_WB
(
	.clk(clk),
	.reset(reset),
	.read_data_w(read_data_w),
	.result_alu_w(pipe_ex_mem_alu_result_w_o),
	.result_pc_plus_4_wb(pipe_ex_mem_pc_plus_4_w),
    //.mux_output_mem_to_reg_w(write_data_w),
	.pc_plus_4_or_pc_jalr_wb(pc_plus_4_or_pc_jalr_wb_w),
	.mem_to_reg_wb_w(pipe_ex_mem_mem_to_reg_mem_w_o),

    .read_data_w_o(pipe_mem_mux_Data_w), // mux_data_1 MUX_MEM_TO_REG

  .result_alu_w_o(pipe_mem_wb_alu_result_w_o),
	.result_pc_plus_4_wb_o(pipe_mem_wb_pc_plus_4_w_),,
	  //.mux_output_mem_to_reg_w_o
	.pc_plus_4_or_pc_jalr_wb_o(pc_plus_4_or_pc_jalr_wb_w_o),
	.mem_to_reg_wb_w_o(pipe_mem_wb_mem_to_reg_wb_w_o)



);

endmodule

