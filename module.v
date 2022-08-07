
module RSA(input wire [0:3] in, output wire[0:3] out, output wire q);
	assign out[0]=in[0];	
	genvar i;
 	 generate for(i = 0; i < 3; i=i+1) begin:RSC_loop
		assign out[i+1]=in[i];end
	 endgenerate
	 assign q = in[3];
endmodule

module RSAio(input wire [0:3] in, input wire k, output wire[0:3] out, output wire q);
	assign out[0]=k;	
	genvar i;
 	 generate for(i = 0; i < 3; i=i+1) begin:RSC_loop
		assign out[i+1]=in[i];end
	 endgenerate
	 assign q = in[3];
endmodule

module addsub (input wire a, b, control, cin, output wire sum, cout);	
	wire [3:0] t;	
	xor2 xas(b, control, t[0]);
	xor2 x0(a, t[0], t[1]);
	xor2 x1(t[1],cin,sum);
	and2 a0(a, t[0], t[2]);
	and2 a1(t[1], cin, t[3]);
	or2 a2(t[2],t[3],cout);
endmodule
module addsubfull(input wire [3:0] i0, i1, input wire control, output wire [3:0] o, output wire cout);
	wire [4:0] c;
	assign c[0] = control;
	genvar i;
 	 generate for(i = 0; i < 4; i=i+1) begin:add_loop
	      addsub as(i0[i], i1[i], control, c[i], o[i], c[i+1]); end
	 endgenerate
	 assign cout = c[4];
endmodule

module dc_slice(input wire clk, reset, cnt, in, output wire q, out);
	wire a, b;
	xor2 xr(q, in, a);
	dfrl dfi(clk, reset, cnt, a, q);
	invert iv1(q,b);
	and2 an(in, b, out);
endmodule
module downctr(input wire clk, reset, cnt, output wire [1:0] op);
	wire [2:0]inp;
	assign inp[0] = cnt;
	genvar i;
 	 generate for(i = 0; i < 2; i=i+1) begin:ctr_loop
		dc_slice sl(clk, reset, cnt, inp[i], op[i], inp[i+1]);end
	 endgenerate
endmodule

