module Mul_Add_Shift_2(
    input iClk_12M,
    input iRsn,
    input iEnSample_300k,
    input [3:0] iEnMul,
    input iEnAdd,
    input iEnAcc,
    input signed [15:0] iShift,
    input signed [2:0] iFirIn,        // FIR input
    input signed [15:0] iCoeff1,       // 16-bit Coefficient 1
    input signed [15:0] iCoeff2,       // 16-bit Coefficient 2
    input signed [15:0] iCoeff3,       // 16-bit Coefficient 3
    input signed [15:0] iCoeff4,       // 16-bit Coefficient 4
    input signed [15:0] iCoeff5,       // 16-bit Coefficient 5
    input signed [15:0] iCoeff6,       // 16-bit Coefficient 6
    input signed [15:0] iCoeff7,       // 16-bit Coefficient 7
    input signed [15:0] iCoeff8,       // 16-bit Coefficient 8
    input signed [15:0] iCoeff9,       // 16-bit Coefficient 9
    input signed [15:0] iCoeff10,      // 16-bit Coefficient 10
    output reg signed [15:0] oMac         // 16-bit Output
);

    reg [15:0] rShift [1:10];  // Shift register array
    wire signed [15:0] wMul [1:10]; // Multiplier wire array

    /*****************************/
    // Multiplier Logic
    /*****************************/
    assign wMul[1] = iFirIn * iCoeff1;
    assign wMul[2] = iFirIn * iCoeff2;
    assign wMul[3] = iFirIn * iCoeff3;
    assign wMul[4] = iFirIn * iCoeff4;
    assign wMul[5] = iFirIn * iCoeff5;
    assign wMul[6] = iFirIn * iCoeff6;
    assign wMul[7] = iFirIn * iCoeff7;
    assign wMul[8] = iFirIn * iCoeff8;
    assign wMul[9] = iFirIn * iCoeff9;
    assign wMul[10] = iFirIn * iCoeff10;

    /*****************************/
    // Sequential Logic for Transposed FIR Filter
    /*****************************/

    // Declare integer variables for loops
    integer j, k;

    always @(posedge iClk_12M) begin
        if (!iRsn) begin
            oMac <= 0;
            // Reset all shift registers
            for (j = 1; j <= 10; j = j + 1) begin
                rShift[j] <= 0;
            end
        end else if (iEnSample_300k) begin
            rShift[1] <= iShift + wMul[1]; // First register gets the FIR input
            for (k = 10; k >= 2; k = k - 1) begin
                rShift[k] <= rShift[k-1] + wMul[k];
            end
            oMac <= rShift[10];
        end
    end

endmodule
