iverilog -o booth booth.v module.v lib.v booth_tb.v
vvp booth
gtkwave booth.vcd
