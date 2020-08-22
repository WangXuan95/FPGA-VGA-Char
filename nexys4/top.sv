`timescale 1ns/1ns

module top(
    input  logic       RESET_N,
    input  logic       CLK100MHZ,
    output logic       VGA_HS, VGA_VS,
    output logic [3:0] VGA_R , VGA_G , VGA_B
);

logic         CLK50MHZ = 1'b0;
logic [25:0]  count = '0;
logic         vga_red, vga_green, vga_blue;
logic         vga_req;
logic [ 6:0]  vga_reqx;
logic [ 4:0]  vga_reqy;
logic [ 6:0]  vga_ascii = '0;
logic [ 6:0]  vga_ascii_base = '0;

assign {VGA_R, VGA_G, VGA_B} = {{4{vga_red}}, {4{vga_green}}, {4{vga_blue}}};

always @ (posedge CLK100MHZ or negedge RESET_N)
    if(~RESET_N)
        CLK50MHZ <= 1'b0;
    else
        CLK50MHZ <= ~CLK50MHZ;

always @ (posedge CLK50MHZ or negedge RESET_N)
    if(~RESET_N) begin
        count <= '0;
        vga_ascii_base <= '0;
    end else begin
        count <= count + 26'd1;
        if(&count)
            vga_ascii_base <= vga_ascii_base + 7'd1;
    end

always @ (posedge CLK50MHZ or negedge RESET_N)
    if(~RESET_N) begin
        vga_ascii <= '0;
    end else begin
        if(vga_req) begin
            vga_ascii <= vga_ascii_base + vga_reqx + {2'd0, vga_reqy};
        end else begin
            vga_ascii <= '0;
        end
    end

vga_char_86x32 vga_char_86x32_i(
    .rst_n     ( RESET_N                 ),
    .clk       ( CLK50MHZ                ),
    .hsync     ( VGA_HS                  ),
    .vsync     ( VGA_VS                  ),
    .red       ( vga_red                 ),
    .green     ( vga_green               ),
    .blue      ( vga_blue                ),
    .req       ( vga_req                 ),
    .reqx      ( vga_reqx                ),
    .reqy      ( vga_reqy                ),
    .ascii     ( vga_ascii               )
);

endmodule

