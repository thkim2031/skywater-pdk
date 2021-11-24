module siso8(in, clk, rst, out);
input in;
input clk;
input rst;
output out;

wire [7:0] ww;

sky130_fd_sc_hd__dfrtp_1 ff0(.D(in),   .Q(ww[0]),.CLK(clk),.RESET_B(rst));
sky130_fd_sc_hd__dfrtp_1 ff1(.D(ww[0]),.Q(ww[1]),.CLK(clk),.RESET_B(rst));
sky130_fd_sc_hd__dfrtp_1 ff2(.D(ww[1]),.Q(ww[2]),.CLK(clk),.RESET_B(rst));
sky130_fd_sc_hd__dfrtp_1 ff3(.D(ww[2]),.Q(ww[3]),.CLK(clk),.RESET_B(rst));
sky130_fd_sc_hd__dfrtp_1 ff4(.D(ww[3]),.Q(ww[4]),.CLK(clk),.RESET_B(rst));
sky130_fd_sc_hd__dfrtp_1 ff5(.D(ww[4]),.Q(ww[5]),.CLK(clk),.RESET_B(rst));
sky130_fd_sc_hd__dfrtp_1 ff6(.D(ww[5]),.Q(ww[6]),.CLK(clk),.RESET_B(rst));
sky130_fd_sc_hd__dfrtp_1 ff7(.D(ww[6]),.Q(out),  .CLK(clk),.RESET_B(rst));

endmodule