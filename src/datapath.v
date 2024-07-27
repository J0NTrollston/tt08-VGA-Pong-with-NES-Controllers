`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: TinyTapeout 8
// Engineer: Brandon S. Ramos
// 
// Create Date: 07/15/2024 05:32:46 PM
// Design Name: 
// Module Name: datapath.v
// Project Name: VGA Pong with NES Controllers
// Target Devices: 
// Tool Versions: 
// Description: Datapath module for pong game
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module datapath(
    input wire clk,
    input wire reset_n,
    
    //VGA timing and picture
    output wire h_sync,
    output wire v_sync,
    output wire r,
    output wire g,
    output wire b,
    
    //NES left controller FSM I/O from datapath to control unit
    input wire [9:0] cw_NESController_Left,
    output wire [1:0] sw_NESController_Left,
    
    //NES right controller FSM I/O from datapath to control unit
    input wire [9:0] cw_NESController_Right,
    output wire [1:0] sw_NESController_Right,
    
    //NES Controller input for left/right
    inout wire [2:0] NES_Controller_Left,
    inout wire [2:0] NES_Controller_Right,
    
    //Ball Movement FSM I/O from datapath to control unit
    output wire [3:0] sw_ballMovement,
    input wire [3:0] cw_ballMovement
    );
    
// Left controller registers
reg [3:0] NES_activity_Left, old_NES_Left;
reg [3:0] NES_wire_Left;
reg [9:0] leftPaddle;

// Right controller registers
reg [3:0] NES_activity_Right, old_NES_Right;
reg [3:0] NES_wire_Right;
reg [9:0] rightPaddle;

//Ball signals
wire [9:0] ball_center_x, ball_center_y;
reg [3:0] sw_ballMovement_reg;
reg ballReset;
wire ballClk; //temp

wire NES_delay_counter_roll;
wire NES_counter_roll;

vga vga(
    .clk(clk),
    .reset_n(reset_n),

    //VGA timing and picture
    .h_sync(h_sync),
    .v_sync(v_sync),
    .r(r),
    .g(g),
    .b(b),
    
    //Location on display for left/right paddles
    .leftPaddle(leftPaddle),
    .rightPaddle(rightPaddle),
    
    //Location on display for the ball
    .ball_center_x(ball_center_x),
    .ball_center_y(ball_center_y)
    );
    
// Used to create the 6us delay to read the left NES controller   
//If using Artix-7 FPGA then counter should be 601 to delay for 6us otherwise 152 when setting up the ASIC
Counter #(.countLimit(152)) NES_counter_left(
    .clk(clk),
    .reset_n(reset_n),
    
    .ctrl(cw_NESController_Left[1:0]),
    .roll(NES_counter_roll)
    );


//// Used to create the 6us delay to read the right NES controller   
//Counter #(.countLimit(152)) NES_counter_right(
//    .clk(clk),
//    .reset_n(reset_n),
    
//    .ctrl(cw_NESController_Right[1:0]),
//    .roll(sw_NESController_Right[0])
//    );

//Polls the Left NES controler button presses 60Hz  
//If using Artix-7 FPGA then counter should be 1666666 to delay for 60Hz otherwise 419583 when setting up the ASIC
Counter #(.countLimit(419583)) NES_delay_counter_left(
    .clk(clk),
    .reset_n(reset_n),
    
    .ctrl(cw_NESController_Left[9:8]),
    .roll(NES_delay_counter_roll)
    );

////Polls the right NES controler button presses 60Hz  
//Counter #(.countLimit(419583)) NES_delay_counter_right(
//    .clk(clk),
//    .reset_n(reset_n),
    
//    .ctrl(cw_NESController_Right[9:8]),
//    .roll(sw_NESController_Right[1])
//    );

// Controls how fast the ball moves
Counter #(.countLimit(100000)) temp(
    .clk(clk),
    .reset_n(reset_n),
    
    .ctrl(2'b01), // always on
    .roll(ballClk)
    );

//Controls the position of the ball based on the control word
ballFunction ballFunction(
    .clk(ballClk), //60hz
    .reset_n(ballReset),
    
    .cw_ballMovement(cw_ballMovement),
    .ball_center_x(ball_center_x),
    .ball_center_y(ball_center_y)
    );

//saves the current state of each button press on each poll of the controller
always @(posedge clk) begin
    if(reset_n == 1'b0) begin
        NES_wire_Left <= 4'd0;
        NES_wire_Right <= 4'd0;
    end else begin
    
        //Left controller input
        case(cw_NESController_Left[7:4])
//            4'b0001 : NES_wire_Left[7] <= NES_Controller_Left[0]; //A
//            4'b0010 : NES_wire_Left[6] <= NES_Controller_Left[0]; //B
            4'b0011 : NES_wire_Left[3] <= NES_Controller_Left[0]; //Select
            4'b0100 : NES_wire_Left[2] <= NES_Controller_Left[0]; //Start
            4'b0101 : NES_wire_Left[1] <= NES_Controller_Left[0]; //Up
            4'b0110 : NES_wire_Left[0] <= NES_Controller_Left[0]; //Down
//            4'b0111 : NES_wire_Left[1] <= NES_Controller_Left[0]; //Left
//            4'b1000 : NES_wire_Left[0] <= NES_Controller_Left[0]; //Right
            default: NES_wire_Left <= 4'b1111;
        endcase
        
        //Right controller input
        case(cw_NESController_Right[7:4])
//            4'b0001 : NES_wire_Right[7] <= NES_Controller_Right[0]; //A
//            4'b0010 : NES_wire_Right[6] <= NES_Controller_Right[0]; //B
            4'b0011 : NES_wire_Right[3] <= NES_Controller_Right[0]; //Select
            4'b0100 : NES_wire_Right[2] <= NES_Controller_Right[0]; //Start
            4'b0101 : NES_wire_Right[1] <= NES_Controller_Right[0]; //Up
            4'b0110 : NES_wire_Right[0] <= NES_Controller_Right[0]; //Down
//            4'b0111 : NES_wire_Right[1] <= NES_Controller_Right[0]; //Left
//            4'b1000 : NES_wire_Right[0] <= NES_Controller_Right[0]; //Right
            default: NES_wire_Right <= 4'b1111;
        endcase
    end
end

always @(posedge clk) begin
    NES_activity_Left <= (old_NES_Left ^ (~NES_wire_Left) ) & ~NES_wire_Left;
    NES_activity_Right <= (old_NES_Right ^ (~NES_wire_Right) ) & ~NES_wire_Right;
    
    if(reset_n == 1'b0) begin
        old_NES_Left <= 8'd0;
        leftPaddle <= 8'd220;
        ballReset <= 1'b0;
        
        old_NES_Right <= 8'd0;
        rightPaddle <= 8'd220;
    end

    if((NES_activity_Left[3] == 1'b1)) begin //Select
        ballReset <= 1'b0;
        leftPaddle <= 8'd220;
        rightPaddle <= 8'd220;
        NES_activity_Left <= 8'd0;
//        NES_activity_Right <= 8'd0;
//        old_NES_Right <= 8'd0;
        old_NES_Left <= 8'd0;
    end else if((NES_activity_Left[2] == 1'b1) ) begin //Start
        ballReset <= 1'b1;
    end else if(NES_activity_Left[1] == 1'b1) begin //Up
        if(leftPaddle - 4'd5 >= 45)
            leftPaddle <= leftPaddle - 4'd5;
    end else if(NES_activity_Left[0] == 1'b1) begin //Down
        if(leftPaddle + 4'd5 <= 395)
            leftPaddle <= leftPaddle + 4'd5;
    end
    
    if(NES_activity_Right[3] == 1'b1) begin //Select
        ballReset <= 1'b0;
        rightPaddle <= 8'd220;
        leftPaddle <= 8'd220;
        NES_activity_Right <= 8'd0;
        old_NES_Right <= 8'd0;
    end else if(NES_activity_Right[2] == 1'b1) begin //Start
        ballReset <= 1'b1;
    end else 
    if(NES_activity_Right[1] == 1'b1) begin //Up
        if(rightPaddle - 4'd5 >= 45)
            rightPaddle <= rightPaddle - 4'd5;
    end else if(NES_activity_Right[0] == 1'b1) begin //Down
        if(rightPaddle + 4'd5 <= 395)
            rightPaddle <= rightPaddle + 4'd5;
    end
    
    old_NES_Left <= ~NES_wire_Left;
    old_NES_Right <= ~NES_wire_Right;
end

//Process to determine set_word for the ball location
always @(posedge ballClk) begin
    if(ball_center_x >= 616 || ball_center_x <= 24) begin //Did the ball hit the left/right boarder past the paddles?
        sw_ballMovement_reg <= 4'b0101;
    end else if(ball_center_y <= 25) //Did the ball hit the top of the screen?
        sw_ballMovement_reg <= 4'b0011;
    else if(ball_center_y == 416) //Did the ball hit the bottom of the screen?
        sw_ballMovement_reg <= 4'b0100;
    else if(ball_center_x == 593 && (ball_center_y > rightPaddle - 30 && ball_center_y < rightPaddle + 30)) //Did the ball hit the right paddle?
        sw_ballMovement_reg <= 4'b0001;
    else if(ball_center_x == 47 && (ball_center_y > leftPaddle - 30 && ball_center_y < leftPaddle + 30)) //Did the ball hit the left paddle?
        sw_ballMovement_reg <= 4'b0010;
    else
//    if(ball_center_x >= 616 || ball_center_x <= 24) begin //Did the ball hit the left/right boarder past the paddles?
//        sw_ballMovement_reg <= 4'b0101;
//    end else
        sw_ballMovement_reg <= 4'b0000;
end

	
//NES communication logic            
assign NES_Controller_Left[1] = cw_NESController_Left[2];
assign NES_Controller_Left[2] = cw_NESController_Left[3];

assign NES_Controller_Right[1] = cw_NESController_Right[2];
assign NES_Controller_Right[2] = cw_NESController_Right[3];
   
assign sw_ballMovement = sw_ballMovement_reg;

assign sw_NESController_Left[1] = NES_delay_counter_roll;
assign sw_NESController_Right[1] = NES_delay_counter_roll;

assign sw_NESController_Left[0] = NES_counter_roll;
assign sw_NESController_Right[0] = NES_counter_roll;

endmodule