
################################################################
# This is a generated script based on design: microprocessor
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2019.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source microprocessor_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# ALU, Accumulator_reg, Decoder, Reg_Great, MUX_2_1, MUX_2_1, My_ROM, Output_Reg, counter, Reg_A, Reg_B, Ring_counter, Shifter, rst_cntrl

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7a100tcsg324-1
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name microprocessor

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set BTNU [ create_bd_port -dir I -type intr BTNU ]
  set_property -dict [ list \
   CONFIG.SENSITIVITY {EDGE_RISING} \
 ] $BTNU
  set CLK100MHZ [ create_bd_port -dir I -type clk -freq_hz 100000000 CLK100MHZ ]
  set CPU_RESETN [ create_bd_port -dir I -type rst CPU_RESETN ]
  set LED [ create_bd_port -dir O -from 7 -to 0 -type data LED ]
  set SW_A [ create_bd_port -dir I -from 3 -to 0 -type data SW_A ]
  set SW_B [ create_bd_port -dir I -from 3 -to 0 -type data SW_B ]

  # Create instance: ALU_0, and set properties
  set block_name ALU
  set block_cell_name ALU_0
  if { [catch {set ALU_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $ALU_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: Accumulator_reg_0, and set properties
  set block_name Accumulator_reg
  set block_cell_name Accumulator_reg_0
  if { [catch {set Accumulator_reg_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Accumulator_reg_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: Decoder_0, and set properties
  set block_name Decoder
  set block_cell_name Decoder_0
  if { [catch {set Decoder_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Decoder_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: IR, and set properties
  set block_name Reg_Great
  set block_cell_name IR
  if { [catch {set IR [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $IR eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: MUX1, and set properties
  set block_name MUX_2_1
  set block_cell_name MUX1
  if { [catch {set MUX1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $MUX1 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: MUX2, and set properties
  set block_name MUX_2_1
  set block_cell_name MUX2
  if { [catch {set MUX2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $MUX2 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: My_ROM_0, and set properties
  set block_name My_ROM
  set block_cell_name My_ROM_0
  if { [catch {set My_ROM_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $My_ROM_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: Output_Reg_0, and set properties
  set block_name Output_Reg
  set block_cell_name Output_Reg_0
  if { [catch {set Output_Reg_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Output_Reg_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: PC, and set properties
  set block_name counter
  set block_cell_name PC
  if { [catch {set PC [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $PC eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: Reg_A_0, and set properties
  set block_name Reg_A
  set block_cell_name Reg_A_0
  if { [catch {set Reg_A_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Reg_A_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: Reg_B_0, and set properties
  set block_name Reg_B
  set block_cell_name Reg_B_0
  if { [catch {set Reg_B_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Reg_B_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: Ring_counter_0, and set properties
  set block_name Ring_counter
  set block_cell_name Ring_counter_0
  if { [catch {set Ring_counter_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Ring_counter_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: Shifter_0, and set properties
  set block_name Shifter
  set block_cell_name Shifter_0
  if { [catch {set Shifter_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Shifter_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: rst_cntrl_0, and set properties
  set block_name rst_cntrl
  set block_cell_name rst_cntrl_0
  if { [catch {set rst_cntrl_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $rst_cntrl_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create port connections
  connect_bd_net -net ALU_0_RESULT [get_bd_pins ALU_0/RESULT] [get_bd_pins Accumulator_reg_0/data_in]
  connect_bd_net -net ALU_0_VALID_OUT [get_bd_pins ALU_0/VALID_OUT] [get_bd_pins Accumulator_reg_0/reg_en]
  connect_bd_net -net Accumulator_reg_0_data_out [get_bd_pins ALU_0/A] [get_bd_pins Accumulator_reg_0/data_out] [get_bd_pins Output_Reg_0/data_in]
  connect_bd_net -net BTNU_1 [get_bd_ports BTNU] [get_bd_pins Ring_counter_0/en]
  connect_bd_net -net CLK100MHZ_1 [get_bd_ports CLK100MHZ] [get_bd_pins ALU_0/CLOCK] [get_bd_pins Accumulator_reg_0/reg_clk] [get_bd_pins Decoder_0/clk] [get_bd_pins IR/reg_clk] [get_bd_pins My_ROM_0/clk] [get_bd_pins Output_Reg_0/reg_clk] [get_bd_pins PC/sys_clk] [get_bd_pins Reg_A_0/reg_clk] [get_bd_pins Reg_B_0/reg_clk] [get_bd_pins Ring_counter_0/clk] [get_bd_pins Shifter_0/clk] [get_bd_pins rst_cntrl_0/clock]
  connect_bd_net -net CPU_RESETN_1 [get_bd_ports CPU_RESETN] [get_bd_pins rst_cntrl_0/reset_in_n]
  connect_bd_net -net Decoder_0_a [get_bd_pins Decoder_0/a] [get_bd_pins Reg_A_0/reg_en]
  connect_bd_net -net Decoder_0_alu [get_bd_pins ALU_0/ENABLE] [get_bd_pins Decoder_0/alu]
  connect_bd_net -net Decoder_0_alu_op [get_bd_pins ALU_0/OP_CODE] [get_bd_pins Decoder_0/alu_op]
  connect_bd_net -net Decoder_0_b [get_bd_pins Decoder_0/b] [get_bd_pins Reg_B_0/reg_en]
  connect_bd_net -net Decoder_0_clraccum [get_bd_pins Accumulator_reg_0/reg_rst] [get_bd_pins Decoder_0/clraccum] [get_bd_pins Ring_counter_0/calc_done]
  connect_bd_net -net Decoder_0_ir [get_bd_pins Decoder_0/ir] [get_bd_pins IR/reg_en]
  connect_bd_net -net Decoder_0_mux1 [get_bd_pins Decoder_0/mux1] [get_bd_pins MUX1/S]
  connect_bd_net -net Decoder_0_mux2 [get_bd_pins Decoder_0/mux2] [get_bd_pins MUX2/S]
  connect_bd_net -net Decoder_0_out [get_bd_pins Decoder_0/out_reg] [get_bd_pins Output_Reg_0/reg_en]
  connect_bd_net -net Decoder_0_pc [get_bd_pins Decoder_0/pc] [get_bd_pins PC/en]
  connect_bd_net -net Decoder_0_s [get_bd_pins Decoder_0/s] [get_bd_pins Shifter_0/s]
  connect_bd_net -net IR_data_out [get_bd_pins Decoder_0/w] [get_bd_pins IR/data_out]
  connect_bd_net -net MUX_2_1_0_Y [get_bd_pins ALU_0/B] [get_bd_pins MUX2/Y]
  connect_bd_net -net MUX_2_1_1_Y [get_bd_pins MUX1/Y] [get_bd_pins MUX2/A] [get_bd_pins Shifter_0/din]
  connect_bd_net -net My_ROM_0_data [get_bd_pins IR/data_in] [get_bd_pins My_ROM_0/data]
  connect_bd_net -net Output_Reg_0_data_out [get_bd_ports LED] [get_bd_pins Output_Reg_0/data_out]
  connect_bd_net -net Reg_A_0_data_out [get_bd_pins MUX1/A] [get_bd_pins Reg_A_0/data_out]
  connect_bd_net -net Reg_B_0_data_out [get_bd_pins MUX1/B] [get_bd_pins Reg_B_0/data_out]
  connect_bd_net -net Ring_counter_0_q [get_bd_pins Decoder_0/en] [get_bd_pins Ring_counter_0/q]
  connect_bd_net -net SW_A_1 [get_bd_ports SW_A] [get_bd_pins Reg_A_0/data_in]
  connect_bd_net -net SW_B_1 [get_bd_ports SW_B] [get_bd_pins Reg_B_0/data_in]
  connect_bd_net -net Shifter_0_flag [get_bd_pins Decoder_0/flag_bit] [get_bd_pins Shifter_0/flag]
  connect_bd_net -net Shifter_0_so [get_bd_pins MUX2/B] [get_bd_pins Shifter_0/so]
  connect_bd_net -net counter_0_cnt [get_bd_pins My_ROM_0/addr] [get_bd_pins PC/cnt]
  connect_bd_net -net rst_CLK100MHZ_100M_peripheral_reset [get_bd_pins ALU_0/RESET] [get_bd_pins Decoder_0/rst] [get_bd_pins IR/reg_rst] [get_bd_pins My_ROM_0/clr] [get_bd_pins Output_Reg_0/reg_rst] [get_bd_pins PC/sys_rst] [get_bd_pins Reg_A_0/reg_rst] [get_bd_pins Reg_B_0/reg_rst] [get_bd_pins Ring_counter_0/clr] [get_bd_pins Shifter_0/rst] [get_bd_pins rst_cntrl_0/reset_out]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


