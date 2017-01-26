#!/bin/bash
vcheck.sh addr16.v addr16.vcheck.out
vcheck.sh alu.v alu.vcheck.out
vcheck.sh alu_arith_block.v alu_arith_block.vcheck.out
vcheck.sh alu_control.v alu_control.vcheck.out
vcheck.sh branch_control.v branch_control.vcheck.out
vcheck.sh branchjump.v branchjump.vcheck.out
vcheck.sh cla4.v cla4.vcheck.out
vcheck.sh cla16.v cla16.vcheck.out
vcheck.sh control.v control.vcheck.out
vcheck.sh decoder3_8.v decoder3_8.vcheck.out
vcheck.sh eightmux8_1.v eightmux8_1.vcheck.out
vcheck.sh non_alu.v non_alu.vcheck.out
vcheck.sh proc.v proc.vcheck.out
vcheck.sh shift_rotate.v shift_rotate.vcheck.out
vcheck.sh shift_rotate_0.v shift_rotate_0.vcheck.out
vcheck.sh shift_rotate_2.v shift_rotate_2.vcheck.out
vcheck.sh shift_rotate_4.v shift_rotate_4.vcheck.out
vcheck.sh shift_rotate_8.v shift_rotate_8.vcheck.out
vcheck.sh sign_extend.v sign_extend.vcheck.out

gedit addr16.vcheck.out alu.vcheck.out alu_arith_block.vcheck.out alu_control.vcheck.out branch_control.vcheck.out branchjump.vcheck.out cla4.vcheck.out cla16.vcheck.out control.vcheck.out decoder3_8.vcheck.out eightmux8_1.vcheck.out non_alu.vcheck.out proc.vcheck.out shift_rotate.vcheck.out shift_rotate_0.vcheck.out shift_rotate_2.vcheck.out shift_rotate_4.vcheck.out shift_rotate_8.vcheck.out
