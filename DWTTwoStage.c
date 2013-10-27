#include <stdio.h>
#include <stdlib.h>
//#include <stddef.h>
#include <math.h>
#include <time.h>

#define ELEMENT_COUNT(X) (sizeof(X) / sizeof((X)[0]))

#define ITERATIONS 100

void printSignal(const char * Name, float * Signal, size_t SignalLen){
	int i;
	
	for (i = 0; i < SignalLen; i++)
	{
		printf("%s[%d] = %f\n", Name, i, Signal[i]);
	}
	printf("\n");
}

void convolve(const float Signal[], int SignalLen, const float filterDB10[], int filterDB10Len, float Result[])
{
	int n;
	
	for (n = 0; n < SignalLen + filterDB10Len - 1; n++)
	{
		int kmin, kmax, k;
		
		Result[n] = 0.0;
		
		kmin = (n >= filterDB10Len - 1) ? n - (filterDB10Len - 1) : 0;
		kmax = (n < SignalLen - 1) ? n : SignalLen - 1;
		
		for (k = kmin; k <= kmax; k++)
		{
			Result[n] += Signal[k] * filterDB10[n - k];
		}
	}
}

void DWTHigh( const float signal[], const int SignalLen, float resultHcomp[]){
	float filterDB10High[] =  { -0.0267, 0.1882, -0.5272, 0.6885, -0.2812, -0.2498, 0.1959, 0.1274, -0.0931, -0.0714, 0.0295, 0.0332,-0.0036, -0.0107, -0.0014, 0.0020, 0.0007, -0.0001, -0.0001, 0.0000};
	int p;
	
	
	const int m = SignalLen+1;
	const int n =  SignalLen +38;//even
	const int q = m + 38;//odd
	const int o = q + 20 - 1;//odd
	const int r = n + 20 - 1;//even
	float x[n];
	float resultHigh[r];
	
	//Lenght test.
	//printf("Tamano resultante de m = %d\n",m);
	//printf("Tamano resultante de q = %d\n",q);
	//printf("Tamano resultante de n = %d\n",n);
	//printf("Tamano resultante de o = %d\n",o);
	//printf("Tamano resultante de r = %d\n",r);
	//printf("Tamano resultante de Elements Filters  = %ld\n",ELEMENT_COUNT(filterDB10High));
	
	for (p = 0; p < (SignalLen + ELEMENT_COUNT(filterDB10High) - 1)/2; p++)
	{
		resultHcomp[p] = 0.0;
	}
	
	for (p = 0; p < 19; p++)
	{
		x[p] = signal[19-p-1];
		x[p+19+SignalLen] = signal[SignalLen-1-p];
		
	}
	
	for(p=0; p < SignalLen; p++){
		
		x[p+19] = signal[p];
		
	}
	
	
	//printSignal("x", x, n);
	//printf("\n");
	
	
	
	convolve(x, ELEMENT_COUNT(x),
			 filterDB10High, ELEMENT_COUNT(filterDB10High),
			 resultHigh);
	p = ELEMENT_COUNT(resultHigh);
	//printSignal("resultHigh", resultHigh, p);
	//printf("\n");
	
	int i;
	for (i = 0; i < (SignalLen + 19)/2; i++ )
	{
		resultHcomp[i] = resultHigh[20+2*i];
	}
	
	//printSignal("resultHcomp", resultHcomp, i);
	//printf("\n");
	
}

void DWTLow( const float signal[], const int SignalLen, float resultLcomp[])
{
	float filterDB10Low[] =  { 0.0000, 0.0001, -0.0001, -0.0007, 0.0020, 0.0014, -0.0107, 0.0036, 0.0332, -0.0295, -0.0714, 0.0931, 0.1274, -0.1959, -0.2498, 0.2812, 0.6885, 0.5272, 0.1882, 0.0267};
	
	int p;
	
	const int n =  SignalLen +38;
	const int r = n + 20 - 1;
	float x[n];
	float resultLow[r];
	
	//Lenght test.
	//printf("Tamano resultante de n = %d\n",n);
	//printf("Tamano resultante de r = %d\n",r);
	//printf("Tamano resultante de Elements Filters  = %ld\n",ELEMENT_COUNT(filterDB10Low));
	
	for (p = 0; p < (SignalLen + ELEMENT_COUNT(filterDB10Low) - 1)/2; p++)
	{
		resultLcomp[p] = 0.0;
	}
	
	for (p = 0; p < 19; p++)
	{
		x[p] = signal[19-p-1];
		x[p+19+SignalLen] = signal[SignalLen-1-p];
		
	}
	
	for(p=0; p < SignalLen; p++){
		
		x[p+19] = signal[p];
		
	}
	
	
	//printSignal("x", x, n);
	//printf("\n");
	
	
	
	convolve(x, ELEMENT_COUNT(x),
			 filterDB10Low, ELEMENT_COUNT(filterDB10Low),
			 resultLow);
	p = ELEMENT_COUNT(resultLow);
	//printSignal("resultLow", resultLow, p);
	//printf("\n");
	
	int i;
	for (i = 0; i < (SignalLen + 19)/2; i++ )
	{
		resultLcomp[i] = resultLow[20+2*i];
	}
	
	//printSignal("resultLcomp", resultLcomp, i);
	//printf("\n");
	
}

void DWTHighRecon( const float resultHigh[], const int resultHighLength, float signalHigh[]){
	
	float reconDB10High[] = { 0.0000, -0.0001, -0.0001, 0.0007, 0.0020, -0.0014,  -0.0107, -0.0036, 0.0332, 0.0295, -0.0714, -0.0931,
		0.1274, 0.1959, -0.2498, -0.2812, 0.6885, -0.5272, 0.1882,-0.0267};
	int m = 2*resultHighLength;
	int f = 20;
	int s = m-f+2;
	int p;
	int l = m-1;
	int h = l+19;
	float y[l];
	float yalt[h];
	float d = (h-s)/2;
	int first = floor(d);
	int last = h-ceil(d);
	
	//Printfs
	//printf("Tamano resultante de m = %d\n",m);
	//printf("Tamano resultante de f = %d\n",f);
	//printf("Tamano resultante de s = %d\n",s);
	//printf("Tamano resultante de p = %d\n",p);
	//printf("Tamano resultante de l = %d\n",l);
	//printf("Tamano resultante de h = %d\n",h);
	//printf("Tamano resultante de d = %f\n",d);
	//printf("Tamano resultante de first = %d\n",first);
	//printf("Tamano resultante de last = %d\n",last);
	//printf("\n");
	
	for(p=0;p<l;p++){
		y[p]=0;
	}
	
	for(p=0; p<resultHighLength; p++){
		y[2*p]=resultHigh[p];
	}
	
	convolve(y, ELEMENT_COUNT(y), reconDB10High, ELEMENT_COUNT(reconDB10High), yalt);
	for(p=first; p<last;p++){
		signalHigh[p-first]=yalt[p];
	}
	
	//printSignal("signalHigh", signalHigh, p-first);
	
	
}

void DWTLowRecon( const float resultLow[], const int resultLowLength, float signalLow[]){
	
	float reconDB10Low[] = { 0.0267, 0.1882, 0.5272, 0.6885, 0.2812, -0.2498, -0.1959, 0.1274, 0.0931, -0.0714, -0.0295, 0.0332,
		0.0036, -0.0107, 0.0014, 0.0020, -0.0007, -0.0001, 0.0001, 0.0000};
	int m = 2*resultLowLength;
	int f = 20;
	int s = m-f+2;
	int p;
	int l = m-1;
	int h = l+19;
	float y[l];
	float yalt[h];
	float d = (h-s)/2;
	int first = floor(d);
	int last = h-ceil(d);
	
	//Printfs
	//printf("Tamano resultante de m = %d\n",m);
	//printf("Tamano resultante de f = %d\n",f);
	//printf("Tamano resultante de s = %d\n",s);
	//printf("Tamano resultante de p = %d\n",p);
	//printf("Tamano resultante de l = %d\n",l);
	//printf("Tamano resultante de h = %d\n",h);
	//printf("Tamano resultante de d = %f\n",d);
	//printf("Tamano resultante de first = %d\n",first);
	//printf("Tamano resultante de last = %d\n",last);
	//printf("\n");
	
	for(p=0;p<l;p++){
		y[p]=0;
	}
	
	for(p=0; p<resultLowLength; p++){
		y[2*p]=resultLow[p];
	}
	
	convolve(y, ELEMENT_COUNT(y), reconDB10Low, ELEMENT_COUNT(reconDB10Low), yalt);
	for(p=first; p<last;p++){
		signalLow[p-first]=yalt[p];
	}
	
	//printSignal("signalLow", signalLow, p-first);
	
	
}

void DWT( const float signal[], const int SignalLen, float resultHcomp[], float resultLcomp[]){
	DWTHigh(signal, SignalLen, resultHcomp);
	DWTLow(signal, SignalLen, resultLcomp);
	
}
void IDWT( const float resultHigh[], const int resultHighLen, const float resultLow[], const int resultLowLen, float signalHigh[], float signalLow[], float reconSign[], int u){
	int g;
	DWTHighRecon(resultHigh, resultHighLen, signalHigh);
	DWTLowRecon(resultLow, resultLowLen, signalLow);
	for(g=0; g<u;g++){
		reconSign[g]=signalHigh[g]+signalLow[g];
	}
	//printSignal("reconSignal", reconSign, u);
	
}

int main(void){
	float signal[] = {Signal Points};
	int signalLen = ELEMENT_COUNT(signal);
	struct timespec begin, end;
	long diff_sec, diff_nsec, m_sec, m_nsec;
	int i;

	//printSignal("signal", signal, signalLen );
	
	int u =(signalLen + 20 - 1)/2;
	int d =(u + 20 - 1)/2;
	int e =(d + 20 - 1)/2;
	int f =(e + 20 - 1)/2;
	int g =(f + 20 - 1)/2;
	
	float resultH[u];
	float resultL[u];
	float resultLH[d];
	float resultLL[d];
	float resultLLH[e];
	float resultLLL[e];
	float resultLLLL[f];
	float resultLLLH[f];
	float resultLLHL[f];
	float resultLLHH[f];
	float resultLLLHL[g];
	float resultLLLHH[g];
	
	float reconSignalLLLH[f];
	float signalLLLHL[f];
	float signalLLLHH[f];
	float reconSignalLLL[e];
	float signalLLLL[e];
	float signalLLLH[e];
	float reconSignalLLH[e];
	float signalLLHH[e];
	float signalLLHL[e];
	float reconSignalLL[d];
	float signalLLH[d];
	float signalLLL[d];
	float reconSignalL[u];
	float signalLH[u];
	float signalLL[u];
	float reconSignal[signalLen];
	float signalH[signalLen];
	float signalL[signalLen];
	
	//printf("Tamano resultante de u = %d\n", u);
	//printf("\n");
	//printf("Tamano resultante de signal = %d\n", signalLen);

	//-------------------COMPRESSION-----------------------
	
	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &begin);

	for(i = 0; i < ITERATIONS; i++)
	{
		DWT(signal, signalLen, resultH, resultL);
		DWT(resultL, u, resultLH, resultLL);
	}

	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end);
	diff_sec = difftime(end.tv_sec, begin.tv_sec);
	diff_nsec = end.tv_nsec > begin.tv_nsec ? end.tv_nsec - begin.tv_nsec : 1000000000 - begin.tv_nsec + end.tv_nsec;

	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &begin);
	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end);
	m_sec = difftime(end.tv_sec, begin.tv_sec);
	m_nsec = end.tv_nsec > begin.tv_nsec ? end.tv_nsec - begin.tv_nsec : 1000000000 - begin.tv_nsec + end.tv_nsec;

	fprintf(stderr, "Compression took %ld.%09ld s\n", diff_sec - m_sec, diff_nsec > m_sec ? diff_nsec - m_sec : 1000000000 - m_sec + diff_nsec);

	//-----------------------------------------------------

	//-----------------DECOMPRESSION-----------------------

	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &begin);
	
	for(i = 0; i < ITERATIONS; i++)
	{
		IDWT(resultLH, d, resultLL, d, signalLH, signalLL, reconSignalL, u);
		IDWT(resultH, u, reconSignalL, u, signalH, signalL, reconSignal,signalLen );
	}

	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end);
	diff_sec = difftime(end.tv_sec, begin.tv_sec);
	diff_nsec = end.tv_nsec > begin.tv_nsec ? end.tv_nsec - begin.tv_nsec : 1000000000 - begin.tv_nsec + end.tv_nsec;

	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &begin);
	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end);
	m_sec = difftime(end.tv_sec, begin.tv_sec);
	m_nsec = end.tv_nsec > begin.tv_nsec ? end.tv_nsec - begin.tv_nsec : 1000000000 - begin.tv_nsec + end.tv_nsec;

	fprintf(stderr, "Decompression took %ld.%09ld s\n", diff_sec - m_sec, diff_nsec > m_sec ? diff_nsec - m_sec : 1000000000 - m_sec + diff_nsec);
	
	//-----------------------------------------------------

	int y;
	float r;
	for(y =0; y< signalLen; y++){
		r =abs(abs(signal[y])-abs(reconSignal[y]));
		if( r > 4*e-2){
			printf("Error recontructing the signal, excceded error");
		}
	}
	
	FILE *filePtr;
	filePtr = fopen("reconSignal.txt","w");
	
	int t;
	for (t = 0; t < signalLen; t++){
		fprintf(filePtr,"%.3g\t,", reconSignal[t]);
	}
	
	fclose(filePtr);
	
	
	return 0;
	
	
}
