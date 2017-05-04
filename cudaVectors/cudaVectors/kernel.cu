
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdlib.h>
#include <time.h>
#include <stdio.h>

__global__ void addition(int *c, int *a, int *b)
{
	int index = (blockIdx.x<<27)+(threadIdx.x<<18)+(threadIdx.y<<9)+threadIdx.z;
	c[index] = a[index] + b[index];
}

int main() {
	int arraySize;
	scanf("%d", &arraySize);
	clock_t start = clock();
	int *a;
	int *b;
	int *c;
	c = (int *)malloc(arraySize*sizeof(int));
	a = (int *)malloc(arraySize*sizeof(int));
	b = (int *)malloc(arraySize*sizeof(int));
	for (int i = 0; i < arraySize; i++) {
		c[i] = 0;
		a[i] = 99999;
		b[i] = 99999;
	}

	int *d_a=0;
	int *d_b=0;
	int *d_c=0;
	cudaMalloc((void **)&d_a, arraySize*sizeof(int));
	cudaMalloc((void **)&d_b, arraySize*sizeof(int));
	cudaMalloc((void **)&d_c, arraySize*sizeof(int));

	cudaMemcpy(d_a, a, arraySize*sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, b, arraySize*sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_c, c, arraySize*sizeof(int), cudaMemcpyHostToDevice);

	//int blocks = (arraySize >> 27);
	addition <<<dim3(10,1,1), dim3(512,512,512)>>>(d_c, d_b, d_a);
	cudaMemcpy(c, d_c, arraySize*sizeof(int), cudaMemcpyDeviceToHost);
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);
	free(a);
	free(b);
	free(c);
	clock_t end = clock();
	float seconds = (float)(end - start) / CLOCKS_PER_SEC;
	printf("time cost: %f\n", seconds);
	/*
	for (int i = 0; i < arraySize;i++) {
		printf("%d ", c[i]);
	}*/
    return 0;
}
