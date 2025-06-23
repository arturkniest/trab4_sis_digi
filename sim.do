vlib work
vmap work work

vcom FPU.vhd
vcom FPU_tb.vhd

vsim FPU_tb

add wave -position insertpoint sim:/FPU_tb/uut/*
add wave -position insertpoint sim:/FPU_tb/*

run 200 ns

view wave
