 /*****************************************************************************
 *                                                                           *
 * Module:       Seven_Segment_Display                                       *
 * Description:                                                              *
 *      This module writes data to Seven Segment Displays.                   *
 *                                                                           *
 *****************************************************************************/

module Seven_Segment_Display (
	// Inputs
	register1,
	display_enable,


	// Bidirectionals

	// Outputs
	seven_segment_display_0,
	seven_segment_display_1,
	seven_segment_display_2,
	seven_segment_display_3

);


/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input [15:0] register1;
input display_enable;

wire	[15:0] register2;
// Bidirectionals

// Outputs
output		[6:0]	seven_segment_display_0;
output		[6:0]	seven_segment_display_1;
output		[6:0]	seven_segment_display_2;
output		[6:0]	seven_segment_display_3;

assign register2 = (display_enable) ? register1:16'h0000;


	hex_digits(register2[3:0],seven_segment_display_0);
	hex_digits(register2[7:4],seven_segment_display_1);
	hex_digits(register2[11:8],seven_segment_display_2);
	hex_digits(register2[15:12],seven_segment_display_3);

	
/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

// Internal Wires

// Internal Registers

// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/


/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/


/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/


endmodule

