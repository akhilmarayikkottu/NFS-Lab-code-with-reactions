SUBROUTINE JETENTER
USE VARIABLES
DOUBLE PRECISION :: NMJ1,ETV
DOUBLE PRECISION :: X,Y,D,VT(3)
DOUBLE PRECISION :: JVEL(3)
INTEGER :: NMJ2,Ori
INTEGER :: SignX,SignY
INTEGER :: P,IMAX

Ori = NM
	DO 100 J =1, NJET
		DO 110 L=1,NSP_T
			IF(SP_EX(L).EQ.1)THEN
				VMP_Local = SQRT(2.*BOLTZ*TMP_J(J)/SP(5,L))
				NMJ1 = ENT_J(J,L)+REM_J(J,L)
				NMJ2 = NMJ1
				REM_J(J,L) = NMJ1-NMJ2
	 			DO 120 NN = 1, NMJ2
					X = (JET(1,J)+RF(0)*(JET(2,J)-JET(1,J)))
					Y = (JET(3,J)+RF(0)*(JET(4,J)-JET(3,J)))					
				IF(X.GE.CB(1).AND.X.LE.CB(2))THEN
					IF(Y.GE.CB(3).AND.Y.LE.CB(4))THEN				

		 				NM = NM + 1 
		 				MJETS(NM) = J
		 				MSTAT(NM) = 2
		 				PP(1,NM) = X
		 				PP(2,NM) = Y
						D = SQRT((X-JET(1,J))**2+(Y-JET(3,J))**2)
						IF(D.LT.VP_J(4,J))JVEL(1) = A_con(1,J)*D**2+B_con(1,J)*D+C_con(1,J)
						IF(D.GE.VP_J(4,J))JVEL(1) = A_con(2,J)*D**2+B_con(2,J)*D+C_con(2,J)
						JVEL(2) = JVEL(1)*COS(JET(7,J))
						JVEL(3) = JVEL(1)*SIN(JET(7,J))
						SignX=JVEL(2)/ABS(JVEL(2))
						SignY=JVEL(3)/ABS(JVEL(3))
						CALL VMPCAL(VT,VMP_Local,L)	
					
					DO 130 P =2,4
						CALL JETVEL(JVEL(P),PP(P+2,NM),L)
												
					!	PP(P+2,NM)=VT(P-1)
					!	IF(P.LE.3)PP(P+2,NM)=JVEL(P)+VT(P-1)
						
130					CONTINUE	
		
					CALL REFINDF(TMP_J(J),L)
					PP(7,NM)=ERS
					PP(8,NM)=EVS
					PP(9,NM) = L
					MSTAT(NM) = 2
					CALL CELLFINDER(NM,PP(1,NM),PP(2,NM))
					END IF
				END IF
120			CONTINUE
			END IF
110 	CONTINUE
100 CONTINUE
ENT=NM-Ori
END SUBROUTINE


SUBROUTINE JETVEL(VEL,UT,L)
 USE VARIABLES
 DOUBLE PRECISION :: A,VEL,UT
 INTEGER :: L
 DOUBLE PRECISION  :: QA,QAF,QAN,SCR

 DOUBLE PRECISION :: FS1,FS2
	 VMP = SQRT(2*BOLTZ*TMP_D/SP(5,L))
 SCR = VEL/VMP
 FS1=SCR+SQRT(SCR*SCR+2.)
 FS2=0.5*(1.+SCR*(2.*SCR-FS1))	
 IF(VEL.GT.1.E-3)THEN
	QA=3.0
	IF ((SCR.LT.-3.).OR.(SCR.GT.3)) QA=ABS(SCR)+1.
12	QAF=-QA+2.*QA*RF(rank)
	QAN=QAF+SCR
	IF (QAN.LT.0.) GO TO 12
	A=(2.*QAN/FS1)*EXP(FS2-QAF*QAF)
	IF (A.LT.RF(rank)) GO TO 12        	
	UT = QAN*VMP
 ELSE
	CALL RVELC(UT,FS2,L)
 END IF
 RETURN
END SUBROUTINE


SUBROUTINE VMPCAL(VT,VMP_Local,L)
 USE VARIABLES
 DOUBLE PRECISION :: VT(3),R1,R2,R3,R4
 INTEGER :: L
 R1=SQRT(-1*LOG(RF(rank)))
 R2=RF(rank)
 R3=RF(rank)
 R4=SQRT(-1*LOG(RF(rank)))
	
     VT(1)=VMP_Local*R1*COS(2*PI*R2)
     VT(2)=VMP_Local*R1*SIN(2*PI*R2)
     VT(3)=VMP_Local*R4*SIN(2*PI*R3)
END SUBROUTINE 