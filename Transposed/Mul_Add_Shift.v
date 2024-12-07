module Mul_Adder_Shift(
    input iClk_12M,
    input iRsn,
    input iEnSample_300k,
    input [3:0] iEnMul,
    input iEnAdd,
    input iEnAcc,

    input iCoeff1,
    input iCoeff2,
    input iCoeff3,
    input iCoeff4,
    input iCoeff5,
    input iCoeff6,
    input iCoeff7,
    input iCoeff8,
    input iCoeff9,
    input iCoeff10,

    input signed [15:0] iFirIn,        // FIR input
    input signed [15:0] iCoeff,       // 16-bit Coefficient
    output reg signed [15:0] oMac         // 16-bit Output
);
    reg [15:0] rShift [1:10];
    wire signed [15:0] wMul [1:10];

    /*****************************/
    // Multiplier Logic using generate block
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
    always @(posedge iClk_12M) begin
        if (!iRsn) begin
            oMac <= 0;
            // Reset all shift registers
            integer j;
            for (j = 1; j <= 10; j = j + 1) begin
                rShift[j] <= 0;
            end
        end else if (iEnSample_300k) begin
            rShift[1] <= wMul[1]; // First register gets the FIR input
            integer k;
            for (k = 10; k >= 2; k = k + 1) begin
                rShift[k] <= rShift[k-1] + wMul[k];
            end
            oMac <= rShift[10];
        end
    end

endmodule
