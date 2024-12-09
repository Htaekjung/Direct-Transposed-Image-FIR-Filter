/*********************************************************************
  - Project          : Team Project (FIR filter w/ Kaiser window)
  - File name        : ReConf_FirFilter.v
  - Description      : Top module
  - Owner            : Hyuntaek.Jung
  - Revision history : 1) 2024.11.26 : Initial release
*********************************************************************/
module ReConf_FirFilter(
	input iClk_12M,
	input iRsn,
	input iCoeffiUpdateFlag,
	input iCsnRam,
	input iWrnRam,
	input [5:0] iAddrRam,
	input signed [15:0] iWrDtRam,
	input [5:0] iNumOfCoeff,//0~40
	input signed [2:0] iFirIn,
	output signed [15:0] oFirOut
	);

	integer i;
	wire wEnAcc;
	wire wEnDelay;
	
	//ram1
	wire wCsnRam;
	wire wWrnRam;
	wire [5:0] wAddrRam;
	wire signed [15:0] wWrDtRam;
	wire signed [15:0] wRdDtRam;
	
	reg  [15:0] rCoeff [1:33];
	
	always @(*) begin
		if (!iRsn) begin
			// Reset 시 모든 Coefficient 초기화
			for (i = 1; i <= 33; i = i + 1) begin
				rCoeff[i] <= 16'h0;
			end
		end
		else if (wCsnRam == 1'b0 && wWrnRam == 1'b1) begin
			// Coefficient Update Phase		
			case (iAddrRam)
				6'd2:   rCoeff[1]  <= wRdDtRam;
				6'd3:   rCoeff[2]  <= wRdDtRam;
				6'd4:   rCoeff[3]  <= wRdDtRam;
				6'd5:   rCoeff[4]  <= wRdDtRam;
				6'd6:   rCoeff[5]  <= wRdDtRam;
				6'd7:   rCoeff[6]  <= wRdDtRam;
				6'd8:   rCoeff[7]  <= wRdDtRam;
				6'd9:   rCoeff[8]  <= wRdDtRam;
				6'd10:  rCoeff[9]  <= wRdDtRam;
				6'd11:  rCoeff[10] <= wRdDtRam;
				6'd12:  rCoeff[11] <= wRdDtRam;
				6'd13:  rCoeff[12] <= wRdDtRam;
				6'd14:  rCoeff[13] <= wRdDtRam;
				6'd15:  rCoeff[14] <= wRdDtRam;
				6'd16:  rCoeff[15] <= wRdDtRam;
				6'd17:  rCoeff[16] <= wRdDtRam;
				6'd18:  rCoeff[17] <= wRdDtRam;
				6'd19:  rCoeff[18] <= wRdDtRam;
				6'd20:  rCoeff[19] <= wRdDtRam;
				6'd21:  rCoeff[20] <= wRdDtRam;
				6'd22:  rCoeff[21] <= wRdDtRam;
				6'd23:  rCoeff[22] <= wRdDtRam;
				6'd24:  rCoeff[23] <= wRdDtRam;
				6'd25:  rCoeff[24] <= wRdDtRam;
				6'd26:  rCoeff[25] <= wRdDtRam;
				6'd27:  rCoeff[26] <= wRdDtRam;
				6'd28:  rCoeff[27] <= wRdDtRam;
				6'd29:  rCoeff[28] <= wRdDtRam;
				6'd30:  rCoeff[29] <= wRdDtRam;
				6'd31:  rCoeff[30] <= wRdDtRam;
				6'd32:  rCoeff[31] <= wRdDtRam;
				6'd33:  rCoeff[32] <= wRdDtRam;
				6'd34:  rCoeff[33] <= wRdDtRam;
				default: ; // No action
			endcase
		end
	end


	//SpSram instance 
    SpSram_Param #(16,33) SpSram1(
        .iClk_12M(iClk_12M),
        .iRsn(iRsn),
        .iCsnRam(wCsnRam),
        .iWrnRam(wWrnRam),
        .iAddrRam(wAddrRam),
        .iWrDtRam(wWrDtRam),
        .oRdDtRam(wRdDtRam)
    );
	
	//FSM
	Controller Controller(
		.iClk_12M(iClk_12M),
        .iRsn(iRsn),
		.iCsnRam(iCsnRam),
        .iWrnRam(iWrnRam),
        .iCoeffiUpdateFlag(iCoeffiUpdateFlag),
        .iAddrRam(iAddrRam),
		.iWrDtRam(iWrDtRam),

        .oEnDelay(wEnDelay), //10개
        .oEnAcc(wEnAcc),
        .oWrDtRam(wWrDtRam),
        .oAddrRam(wAddrRam),
        .oWrnRam(wWrnRam),
        .oCsnRam(wCsnRam)
	);

//역할 : iFirIn과 coeff 10개를 동시에 곱해서 shift register까지 구현해서 계속 넘기면서 출력값은 wire로 출력 
	Mul_Add_Shift_Output MAS_1(
		.iClk_12M(iClk_12M),
		.iRsn(iRsn),
		.iEnAcc(wEnAcc),
		.iFirIn(iFirIn),
		.iCoeff1(rCoeff[1]),
		.iCoeff2(rCoeff[2]),
		.iCoeff3(rCoeff[3]),
		.iCoeff4(rCoeff[4]),
		.iCoeff5(rCoeff[5]),
		.iCoeff6(rCoeff[6]),
		.iCoeff7(rCoeff[7]),
		.iCoeff8(rCoeff[8]),
		.iCoeff9(rCoeff[9]),
		.iCoeff10(rCoeff[10]),
		.iCoeff11(rCoeff[11]),
		.iCoeff12(rCoeff[12]),
		.iCoeff13(rCoeff[13]),
		.iCoeff14(rCoeff[14]),
		.iCoeff15(rCoeff[15]),
		.iCoeff16(rCoeff[16]),
		.iCoeff17(rCoeff[17]),
		.iCoeff18(rCoeff[18]),
		.iCoeff19(rCoeff[19]),
		.iCoeff20(rCoeff[20]),
		.iCoeff21(rCoeff[21]),
		.iCoeff22(rCoeff[22]),
		.iCoeff23(rCoeff[23]),
		.iCoeff24(rCoeff[24]),
		.iCoeff25(rCoeff[25]),
		.iCoeff26(rCoeff[26]),
		.iCoeff27(rCoeff[27]),
		.iCoeff28(rCoeff[28]),
		.iCoeff29(rCoeff[29]),
		.iCoeff30(rCoeff[30]),
		.iCoeff31(rCoeff[31]),
		.iCoeff32(rCoeff[32]),
		.iCoeff33(rCoeff[33]),
		.oFirOut(oFirOut)
	);

endmodule
	
	
	
	