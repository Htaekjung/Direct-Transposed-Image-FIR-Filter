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
	input [3:0] iAddrRam,
	input signed [15:0] iWrDtRam,
	input [5:0] iNumOfCoeff,//0~40
	input signed [2:0] iFirIn,
	output signed [15:0] oFirOut
	);
	//reg [15:0] RdDtRam1, oRdDtRam2, oRdDtRam3, oRdDtRam4;
	//parameter

	integer i;

	wire wEnAcc1, wEnAcc2, wEnAcc3, wEnAcc4;
	wire wEnDelay;
	
	//ram1
	wire wCsnRam1;
	wire wWrnRam1;
	wire [3:0] wAddrRam1;
	wire signed [15:0] wWrDtRam1;
	wire signed [15:0] wRdDtRam1;

	//ram2
	wire wCsnRam2;
	wire wWrnRam2;
	wire [3:0] wAddrRam2;
	wire signed [15:0] wWrDtRam2;
	wire signed [15:0] wRdDtRam2;

	//ram3
	wire wCsnRam3;
	wire wWrnRam3;
	wire [3:0] wAddrRam3;
	wire signed [15:0] wWrDtRam3;
	wire signed [15:0] wRdDtRam3;

	//ram4
	wire wCsnRam4;
	wire wWrnRam4;
	wire [3:0] wAddrRam4;
	wire signed [15:0] wWrDtRam4;
	wire signed [15:0] wRdDtRam4;
	
	wire signed [15:0] wMac1;
	wire signed [15:0] wMac2;
	wire signed [15:0] wMac3;
	
	reg  [15:0] rCoeff [1:33];
	integer j,k,l;
	
	always @(*) begin
		if (!iRsn) begin
			// Reset 시 모든 Coefficient 초기화
			for (i = 1; i <= 10; i = i + 1) begin
				rCoeff[i] <= 16'h0;
			end
		end
		else if (wCsnRam1 == 1'b0 && wWrnRam1 == 1'b1) begin
			// Coefficient Update Phase		
			case (iAddrRam)
				6'd2:  rCoeff[1]  <= wRdDtRam1;
				6'd3:  rCoeff[2]  <= wRdDtRam1;
				6'd4:  rCoeff[3]  <= wRdDtRam1;
				6'd5:  rCoeff[4]  <= wRdDtRam1;
				6'd6:  rCoeff[5]  <= wRdDtRam1;
				6'd7:  rCoeff[6]  <= wRdDtRam1;
				6'd8:  rCoeff[7]  <= wRdDtRam1;
				6'd9:  rCoeff[8]  <= wRdDtRam1;
				6'd10:  rCoeff[9]  <= wRdDtRam1;
				6'd11: rCoeff[10] <= wRdDtRam1;
				default: ; // No action
			endcase
		end
	end	
		
	always @(*) begin
		if (!iRsn) begin
			// Reset 시 모든 Coefficient 초기화
			for (j = 11; j <= 20; j = j + 1) begin
				rCoeff[j] <= 16'h0;
			end
		end
		else if (wCsnRam2 == 1'b0 && wWrnRam2 == 1'b1) begin
			case (iAddrRam)
				6'd2:  rCoeff[11] <= wRdDtRam2;
				6'd3:  rCoeff[12] <= wRdDtRam2;
				6'd4:  rCoeff[13] <= wRdDtRam2;
				6'd5:  rCoeff[14] <= wRdDtRam2;
				6'd6:  rCoeff[15] <= wRdDtRam2;
				6'd7:  rCoeff[16] <= wRdDtRam2;
				6'd8:  rCoeff[17] <= wRdDtRam2;
				6'd9:  rCoeff[18] <= wRdDtRam2;
				6'd10:  rCoeff[19] <= wRdDtRam2;
				6'd11: rCoeff[20] <= wRdDtRam2;
				default: ; // No action
			endcase
		end
	end
	
	always @(*) begin
		if (!iRsn) begin
			// Reset 시 모든 Coefficient 초기화
			for (k = 21; k <= 30; k = k + 1) begin
				rCoeff[k] <= 16'h0;
			end
		end	
		else if (wCsnRam3 == 1'b0  && wWrnRam3 == 1'b1) begin
			case (iAddrRam)
				6'd2:  rCoeff[21] <= wRdDtRam3;
				6'd3:  rCoeff[22] <= wRdDtRam3;
				6'd4:  rCoeff[23] <= wRdDtRam3;
				6'd5:  rCoeff[24] <= wRdDtRam3;
				6'd6:  rCoeff[25] <= wRdDtRam3;
				6'd7:  rCoeff[26] <= wRdDtRam3;
				6'd8:  rCoeff[27] <= wRdDtRam3;
				6'd9:  rCoeff[28] <= wRdDtRam3;
				6'd10:  rCoeff[29] <= wRdDtRam3;
				6'd11: rCoeff[30] <= wRdDtRam3;
				default: ; // No action
			endcase
		end
	end
	
	always @(*) begin
		if (!iRsn) begin
			// Reset 시 모든 Coefficient 초기화
			for (l = 31; l <= 33; l = l + 1) begin
				rCoeff[l] <= 16'h0;
			end
		end	
		else if (wCsnRam4 == 1'b0 && wWrnRam4 == 1'b1) begin
			case (iAddrRam)
				6'd2: rCoeff[31] <= wRdDtRam4;
				6'd3: rCoeff[32] <= wRdDtRam4;
				6'd4: rCoeff[33] <= wRdDtRam4;
				default: ; // No action
			endcase
		end	
	end


	//SpSram instance 
    SpSram_10x16 SpSram1(
        .iClk_12M(iClk_12M),
        .iRsn(iRsn),
        .iCsnRam(wCsnRam1),
        .iWrnRam(wWrnRam1),
        .iAddrRam(wAddrRam1),
        .iWrDtRam(wWrDtRam1),
        .oRdDtRam(wRdDtRam1)
    );
	
    SpSram_10x16 SpSram2(
        .iClk_12M(iClk_12M),
        .iRsn(iRsn),
        .iCsnRam(wCsnRam2),
        .iWrnRam(wWrnRam2),
        .iAddrRam(wAddrRam2),
        .iWrDtRam(wWrDtRam2),
        .oRdDtRam(wRdDtRam2)
    );

    SpSram_10x16 SpSram3(
        .iClk_12M(iClk_12M),
        .iRsn(iRsn),
        .iCsnRam(wCsnRam3),
        .iWrnRam(wWrnRam3),
        .iAddrRam(wAddrRam3),
        .iWrDtRam(wWrDtRam3),
        .oRdDtRam(wRdDtRam3)
    );

    SpSram_10x16 SpSram4(
        .iClk_12M(iClk_12M),
        .iRsn(iRsn),
        .iCsnRam(wCsnRam4),
        .iWrnRam(wWrnRam4),
        .iAddrRam(wAddrRam4),
        .iWrDtRam(wWrDtRam4),
        .oRdDtRam(wRdDtRam4)
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
		.iNumOfCoeff(iNumOfCoeff),
        .oEnDelay(wEnDelay), //10개

        .oEnAcc1(wEnAcc1),
        .oEnAcc2(wEnAcc2),
        .oEnAcc3(wEnAcc3),
        .oEnAcc4(wEnAcc4),//12개

        // Outputs for RAMs
        .oWrDtRam1(wWrDtRam1),
        .oAddrRam1(wAddrRam1),
        .oWrnRam1(wWrnRam1),
        .oCsnRam1(wCsnRam1),

        .oWrDtRam2(wWrDtRam2),
        .oAddrRam2(wAddrRam2),
        .oWrnRam2(wWrnRam2),
        .oCsnRam2(wCsnRam2),

        .oWrDtRam3(wWrDtRam3),
        .oAddrRam3(wAddrRam3),
        .oWrnRam3(wWrnRam3),
        .oCsnRam3(wCsnRam3),

        .oWrDtRam4(wWrDtRam4),
        .oAddrRam4(wAddrRam4),
        .oWrnRam4(wWrnRam4),
        .oCsnRam4(wCsnRam4)
	);


//역할 : iFirIn과 coeff 10개를 동시에 곱해서 shift register까지 구현해서 계속 넘기면서 출력값은 wire로 출력 
	Mul_Add_Shift MAS_1(
		.iClk_12M(iClk_12M),
		.iRsn(iRsn),
		.iEnAcc(wEnAcc1),
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
		.oMac(wMac1)
	);
//역할 : iFirIn과 coeff 10개를 동시에 곱해서 shift register까지 구현해서 계속 넘기면서 출력값은 wire로 출력
	Mul_Add_Shift_2 MAS_2(
		.iClk_12M(iClk_12M),
		.iRsn(iRsn),
		.iEnAcc(wEnAcc2),
		.iShift(wMac1),
		.iFirIn(iFirIn),
		.iCoeff1(rCoeff[11]),
		.iCoeff2(rCoeff[12]),
		.iCoeff3(rCoeff[13]),
		.iCoeff4(rCoeff[14]),
		.iCoeff5(rCoeff[15]),
		.iCoeff6(rCoeff[16]),
		.iCoeff7(rCoeff[17]),
		.iCoeff8(rCoeff[18]),
		.iCoeff9(rCoeff[19]),
		.iCoeff10(rCoeff[20]),
		.oMac(wMac2)
	);
//역할 : iFirIn과 coeff 10개를 동시에 곱해서 shift register까지 구현해서 계속 넘기면서 출력값은 wire로 출력
	Mul_Add_Shift_2 MAS_3(
		.iClk_12M(iClk_12M),
		.iRsn(iRsn),
		.iEnAcc(wEnAcc3),
		.iShift(wMac2),
		.iFirIn(iFirIn),
		.iCoeff1(rCoeff[21]),
		.iCoeff2(rCoeff[22]),
		.iCoeff3(rCoeff[23]),
		.iCoeff4(rCoeff[24]),
		.iCoeff5(rCoeff[25]),
		.iCoeff6(rCoeff[26]),
		.iCoeff7(rCoeff[27]),
		.iCoeff8(rCoeff[28]),
		.iCoeff9(rCoeff[29]),
		.iCoeff10(rCoeff[30]),
		.oMac(wMac3)
	);
//역할 : iFirIn과 coeff 10개를 동시에 곱해서 shift register까지 구현해서 계속 넘기면서 출력값은 wire로 출력
	Mul_Add_Shift_Output MAS_Final(
		.iClk_12M(iClk_12M),
		.iRsn(iRsn),
		.iShift(wMac3),
		.iEnAcc(wEnAcc4),
		.iFirIn(iFirIn),
		.iCoeff1(rCoeff[31]),
		.iCoeff2(rCoeff[32]),
		.iCoeff3(rCoeff[33]),
		.oFirOut(oFirOut)
	);
endmodule
	
	
	
	