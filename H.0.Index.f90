SUBROUTINE INDEX
USE VARIABLES
INTEGER :: MC,MSC,K,Q,NN
	  DO 100 L=1,NSP_T
	  	IG(2,L)=0 
	  	DO 110 N=1,NC_D
			IC(2,N,L)=0 			
110  CONTINUE
	  	DO 120 M=1,NSC_D
			ISCG(2,M,L)=0 			
120  CONTINUE 
100 CONTINUE 
  DO 200 I=1,NM
	  		L=PP(9,I)
			IG(2,L)=IG(2,L)+1
			MSC=IP(I)		
			ISCG(2,MSC,L)=ISCG(2,MSC,L)+1 	
			MC=ISC(MSC)			
			IC(2,MC,L)=IC(2,MC,L)+1 		   
200  CONTINUE
Q=0
	  DO 300 L=1,NSP_T
IF(SP_EX(L).EQ.1)THEN
			IG(1,L)=Q 			
			Q=Q+IG(2,L) 			
END IF
300 CONTINUE
 
	  DO 400 L=1,NSP_T
IF(SP_EX(L).EQ.1)THEN
			Q=IG(1,L)
	  	DO 410 N=1,NC_D
				IC(1,N,L)=Q 			
				Q=Q+IC(2,N,L) 			
410 	CONTINUE	
		Q=IG(1,L)
	   DO 420 M=1,NSC_D
				ISCG(1,M,L)=Q 			
				Q=Q+ISCG(2,M,L) 			
				ISCG(2,M,L)=0 			
420 	 CONTINUE
END IF
400  CONTINUE
	   DO 500 I=1,NM
	   	L=PP(9,I)
			MSC=IP(I) 			
			ISCG(2,MSC,L)=ISCG(2,MSC,L)+1 	
			K=ISCG(1,MSC,L)+ISCG(2,MSC,L) 	
			IR(K)=I
500	CONTINUE
RETURN
END SUBROUTINE
