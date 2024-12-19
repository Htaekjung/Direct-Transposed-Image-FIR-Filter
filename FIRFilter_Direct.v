/*********************************************************************
  - Project          : Direct form vs Transposed form
  - File name        : ReConf_FirFilter_Direct.v
  - Description      : Direct form Top module 
  - Owner            : Hyuntaek.Jung
  - Revision history : 1) 2024.12.10 : Initial release
*********************************************************************/
module FIRFilter_Direct(
	input iClk_12M,
	input iRsn,
	input iCoeffiUpdateFlag,
	input iCsnRam,
	input iWrnRam,
	input [5:0] iAddrRam,
	input signed [15:0] iWrDtRam,
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
	
	wire  [15:0] wCoeff [1:33];



	//SpSram instance 
    SpSram_Param_Direct #(16,33) SpSram1(
        .iClk_12M(iClk_12M),
        .iRsn(iRsn),
        .iCsnRam(wCsnRam),
        .iWrnRam(wWrnRam),
        .iAddrRam(wAddrRam),
        .iWrDtRam(wWrDtRam),
        .oCoeff1(wCoeff[1]),
        .oCoeff2(wCoeff[2]),
        .oCoeff3(wCoeff[3]),
        .oCoeff4(wCoeff[4]),
        .oCoeff5(wCoeff[5]),
        .oCoeff6(wCoeff[6]),
        .oCoeff7(wCoeff[7]),
        .oCoeff8(wCoeff[8]),
        .oCoeff9(wCoeff[9]),
        .oCoeff10(wCoeff[10]),
        .oCoeff11(wCoeff[11]),
        .oCoeff12(wCoeff[12]),
        .oCoeff13(wCoeff[13]),
        .oCoeff14(wCoeff[14]),
        .oCoeff15(wCoeff[15]),
        .oCoeff16(wCoeff[16]),
        .oCoeff17(wCoeff[17]),
        .oCoeff18(wCoeff[18]),
        .oCoeff19(wCoeff[19]),
        .oCoeff20(wCoeff[20]),
        .oCoeff21(wCoeff[21]),
        .oCoeff22(wCoeff[22]),
        .oCoeff23(wCoeff[23]),
        .oCoeff24(wCoeff[24]),
        .oCoeff25(wCoeff[25]),
        .oCoeff26(wCoeff[26]),
        .oCoeff27(wCoeff[27]),
        .oCoeff28(wCoeff[28]),
        .oCoeff29(wCoeff[29]),
        .oCoeff30(wCoeff[30]),
        .oCoeff31(wCoeff[31]),
        .oCoeff32(wCoeff[32]),
        .oCoeff33(wCoeff[33])
    );
	
	//FSM
	Controller_Direct Controller(
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
	Cal_Shift_Output_Direct MAS_1(
		.iClk_12M(iClk_12M),
		.iRsn(iRsn),
		.iEnAcc(wEnAcc),
		.iFirIn(iFirIn),
		.iCoeff1(wCoeff[1]),
		.iCoeff2(wCoeff[2]),
		.iCoeff3(wCoeff[3]),
		.iCoeff4(wCoeff[4]),
		.iCoeff5(wCoeff[5]),
		.iCoeff6(wCoeff[6]),
		.iCoeff7(wCoeff[7]),
		.iCoeff8(wCoeff[8]),
		.iCoeff9(wCoeff[9]),
		.iCoeff10(wCoeff[10]),
		.iCoeff11(wCoeff[11]),
		.iCoeff12(wCoeff[12]),
		.iCoeff13(wCoeff[13]),
		.iCoeff14(wCoeff[14]),
		.iCoeff15(wCoeff[15]),
		.iCoeff16(wCoeff[16]),
		.iCoeff17(wCoeff[17]),
		.iCoeff18(wCoeff[18]),
		.iCoeff19(wCoeff[19]),
		.iCoeff20(wCoeff[20]),
		.iCoeff21(wCoeff[21]),
		.iCoeff22(wCoeff[22]),
		.iCoeff23(wCoeff[23]),
		.iCoeff24(wCoeff[24]),
		.iCoeff25(wCoeff[25]),
		.iCoeff26(wCoeff[26]),
		.iCoeff27(wCoeff[27]),
		.iCoeff28(wCoeff[28]),
		.iCoeff29(wCoeff[29]),
		.iCoeff30(wCoeff[30]),
		.iCoeff31(wCoeff[31]),
		.iCoeff32(wCoeff[32]),
		.iCoeff33(wCoeff[33]),
		.oFirOut(oFirOut)
	);

endmodule
	
	
	
	