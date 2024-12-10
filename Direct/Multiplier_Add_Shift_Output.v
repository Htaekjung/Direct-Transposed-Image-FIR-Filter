/*********************************************************************
  - Project          : Direct form vs Transposed form
  - File name        : Cal_Shift_Output.v
  - Description      : Calculate & Register shift & output
  - Owner            : Hyuntaek.Jung
  - Revision history : 1) 2024.12.10 : Initial release
*********************************************************************/
module Mul_Add_Shift_Output(
    input wire iClk_12M,
    input wire iRsn,
    input wire iEnAcc,
    input signed [2:0] iFirIn,      // FIR input
    input signed [15:0] iCoeff1,
    input signed [15:0] iCoeff2,
    input signed [15:0] iCoeff3,
    input signed [15:0] iCoeff4,
    input signed [15:0] iCoeff5,
    input signed [15:0] iCoeff6,
    input signed [15:0] iCoeff7,
    input signed [15:0] iCoeff8,
    input signed [15:0] iCoeff9,
    input signed [15:0] iCoeff10,
    input signed [15:0] iCoeff11,
    input signed [15:0] iCoeff12,
    input signed [15:0] iCoeff13,
    input signed [15:0] iCoeff14,
    input signed [15:0] iCoeff15,
    input signed [15:0] iCoeff16,
    input signed [15:0] iCoeff17,
    input signed [15:0] iCoeff18,
    input signed [15:0] iCoeff19,
    input signed [15:0] iCoeff20,
    input signed [15:0] iCoeff21,
    input signed [15:0] iCoeff22,
    input signed [15:0] iCoeff23,
    input signed [15:0] iCoeff24,
    input signed [15:0] iCoeff25,
    input signed [15:0] iCoeff26,
    input signed [15:0] iCoeff27,
    input signed [15:0] iCoeff28,
    input signed [15:0] iCoeff29,
    input signed [15:0] iCoeff30,
    input signed [15:0] iCoeff31,
    input signed [15:0] iCoeff32,
    input signed [15:0] iCoeff33,
    output reg signed [15:0] oFirOut // FIR filter output
);

    // Internal Registers and Wires
    reg signed [15:0] rShift [0:31];   // 32 Shift registers
    wire signed [15:0] wCoeff [0:32];

    integer i;                        // Loop variable

    // Coefficients wiring
    assign wCoeff[0]  = iCoeff1;
    assign wCoeff[1]  = iCoeff2;
    assign wCoeff[2]  = iCoeff3;
    assign wCoeff[3]  = iCoeff4;
    assign wCoeff[4]  = iCoeff5;
    assign wCoeff[5]  = iCoeff6;
    assign wCoeff[6]  = iCoeff7;
    assign wCoeff[7]  = iCoeff8;
    assign wCoeff[8]  = iCoeff9;
    assign wCoeff[9]  = iCoeff10;
    assign wCoeff[10] = iCoeff11;
    assign wCoeff[11] = iCoeff12;
    assign wCoeff[12] = iCoeff13;
    assign wCoeff[13] = iCoeff14;
    assign wCoeff[14] = iCoeff15;
    assign wCoeff[15] = iCoeff16;
    assign wCoeff[16] = iCoeff17;
    assign wCoeff[17] = iCoeff18;
    assign wCoeff[18] = iCoeff19;
    assign wCoeff[19] = iCoeff20;
    assign wCoeff[20] = iCoeff21;
    assign wCoeff[21] = iCoeff22;
    assign wCoeff[22] = iCoeff23;
    assign wCoeff[23] = iCoeff24;
    assign wCoeff[24] = iCoeff25;
    assign wCoeff[25] = iCoeff26;
    assign wCoeff[26] = iCoeff27;
    assign wCoeff[27] = iCoeff28;
    assign wCoeff[28] = iCoeff29;
    assign wCoeff[29] = iCoeff30;
    assign wCoeff[30] = iCoeff31;
    assign wCoeff[31] = iCoeff32;
    assign wCoeff[32] = iCoeff33;


    // Sequential Logic
    always @(posedge iClk_12M) begin
        if (!iRsn) begin
            // Reset logic
            oFirOut <= 0;
            for (i = 0; i < 32; i = i + 1) begin
                rShift[i] <= 0;
            end
        end else if (iEnAcc) begin
            // Calculate FIR filter output using Direct Form
            oFirOut = wCoeff[32] * iFirIn; // Current input contribution
            for (i = 0; i <= 31; i = i + 1) begin
                oFirOut = oFirOut + wCoeff[i] * rShift[31-i];
            end
            
            // Update Shift Register
            rShift[0] <= iFirIn; // Store current input in the first register
            for (i = 1; i < 32; i = i + 1) begin
                rShift[i] <= rShift[i-1];
            end
        end
    end

endmodule