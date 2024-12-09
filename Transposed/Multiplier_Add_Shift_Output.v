module Mul_Add_Shift_Output(
    input wire iClk_12M,
    input wire iRsn,
    input wire iEnAcc,
    input signed [15:0] iFirIn,      // FIR input
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
    wire signed [15:0] wMul [0:32];   // Multipliers
    integer i;                        // Loop variable

    /*****************************/
    // Multiplier Logic
    /*****************************/
    assign wMul[0]  = iFirIn * iCoeff1;
    assign wMul[1]  = iFirIn * iCoeff2;
    assign wMul[2]  = iFirIn * iCoeff3;
    assign wMul[3]  = iFirIn * iCoeff4;
    assign wMul[4]  = iFirIn * iCoeff5;
    assign wMul[5]  = iFirIn * iCoeff6;
    assign wMul[6]  = iFirIn * iCoeff7;
    assign wMul[7]  = iFirIn * iCoeff8;
    assign wMul[8]  = iFirIn * iCoeff9;
    assign wMul[9]  = iFirIn * iCoeff10;
    assign wMul[10] = iFirIn * iCoeff11;
    assign wMul[11] = iFirIn * iCoeff12;
    assign wMul[12] = iFirIn * iCoeff13;
    assign wMul[13] = iFirIn * iCoeff14;
    assign wMul[14] = iFirIn * iCoeff15;
    assign wMul[15] = iFirIn * iCoeff16;
    assign wMul[16] = iFirIn * iCoeff17;
    assign wMul[17] = iFirIn * iCoeff18;
    assign wMul[18] = iFirIn * iCoeff19;
    assign wMul[19] = iFirIn * iCoeff20;
    assign wMul[20] = iFirIn * iCoeff21;
    assign wMul[21] = iFirIn * iCoeff22;
    assign wMul[22] = iFirIn * iCoeff23;
    assign wMul[23] = iFirIn * iCoeff24;
    assign wMul[24] = iFirIn * iCoeff25;
    assign wMul[25] = iFirIn * iCoeff26;
    assign wMul[26] = iFirIn * iCoeff27;
    assign wMul[27] = iFirIn * iCoeff28;
    assign wMul[28] = iFirIn * iCoeff29;
    assign wMul[29] = iFirIn * iCoeff30;
    assign wMul[30] = iFirIn * iCoeff31;
    assign wMul[31] = iFirIn * iCoeff32;
    assign wMul[32] = iFirIn * iCoeff33;


    /*****************************/
    // Sequential Logic
    /*****************************/
    always @(posedge iClk_12M or negedge iRsn) begin
        if (!iRsn) begin
            // Reset all registers
            for (i = 0; i < 32; i = i + 1) begin
                rShift[i] <= 16'd0;
            end
            oFirOut <= 16'd0;
        end else if (iEnAcc) begin
            // Shift and accumulate
            rShift[0] <= wMul[0];
            for (i = 1; i < 32; i = i + 1) begin
                rShift[i] <= rShift[i - 1] + wMul[i];
            end
            oFirOut <= rShift[31] + wMul[32];
        end
    end
endmodule
