`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: TinyTapeout 8
// Engineer: Brandon S. Ramos
// 
// Create Date: 07/14/2024 09:34:48 PM
// Design Name: 
// Module Name: video.v
// Project Name: VGA Pong with NES Controllers
// Target Devices: 
// Tool Versions: 
// Description: Intermediate module for the VGA display interface
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module video(
    input wire clk,
    input wire reset_n,

    //VGA timing and picture
    output wire h_sync,
    output wire v_sync,
    output wire r,
    output wire g,
    output wire b,
    
    input wire [9:0] leftPaddle,
    input wire [9:0] rightPaddle,
    
    input wire [9:0] ball_center_x,
    input wire [9:0] ball_center_y
    );
    
vga vga(
    .clk(clk),
    .reset_n(reset_n),

    //VGA timing and picture
    .h_sync(h_sync),
    .v_sync(v_sync),
    .r(r),
    .g(g),
    .b(b),
    
    .leftPaddle(leftPaddle),
    .rightPaddle(rightPaddle),
    
    .ball_center_x(ball_center_x),
    .ball_center_y(ball_center_y)
    );
    
endmodule