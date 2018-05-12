#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <semaphore.h>

// 缓冲区大小
#define N 20
// 数据文件路径 
#define DATAFILE_PATH "./data.txt"
typedef char item;

// 互斥量 用于互斥访问缓冲区
pthread_mutex_t mutex;
// 资源信号量 用于生产者于消费者之间同步
sem_t empty,full;
// 用于标记生产和消费的产品位置
int in=0,out=0;
// 缓冲区
item buffer[N];

// 文件指针
FILE *fp;

void* producer(void* arg){
	int i = *(int*)arg;
	item nextp;
	while(1){
		// 生产数据
		sleep(1);
		nextp=fgetc(fp);
		printf("生产者%d生产了一个数据\n",i);
		
		sem_wait(&empty);
		pthread_mutex_lock(&mutex);

		// 将数据放入缓冲区中
		buffer[in]=nextp;
		in=(in+1)%N;

		pthread_mutex_unlock(&mutex);
		sem_post(&full);
	}
}

void* consumer(void* arg){
	int i = *(int*)arg;
	item nextc;
	while(1){
		sem_wait(&full);
		pthread_mutex_lock(&mutex);

		// 将数据从缓冲区中取出
		nextc=buffer[out];
		out=(out+1)%N;

		pthread_mutex_unlock(&mutex);
		sem_post(&empty);

		// 消费数据
		sleep(1);
		printf("消费者%d消费了一个数据：%c\n",i,nextc);
	}
}

int main(){
	pthread_t p1,p2,p3,c1,c2,c3,c4;

	// 初始化互斥量
	pthread_mutex_init(&mutex,NULL);
	// 初始化信号量
	sem_init(&empty,1,N);
	sem_init(&full,1,0);

	// 初始化文件指针
	fp = fopen(DATAFILE_PATH,"r");

	int i[4]={1,2,3,4};
	// 创建生产者线程
	pthread_create(&p1,NULL,producer,&i[0]);
	pthread_create(&p2,NULL,producer,&i[1]);
	pthread_create(&p3,NULL,producer,&i[2]);

	// 创建消费者线程
	pthread_create(&c1,NULL,consumer,&i[0]);
	pthread_create(&c2,NULL,consumer,&i[1]);
	pthread_create(&c3,NULL,consumer,&i[2]);
	pthread_create(&c4,NULL,consumer,&i[3]);

	// 等待线程结束
	pthread_join(p1,NULL);
	pthread_join(p2,NULL);
	pthread_join(p3,NULL);
	pthread_join(c1,NULL);
	pthread_join(c2,NULL);
	pthread_join(c3,NULL);
	pthread_join(c4,NULL);	

	// 关闭文件
	fclose(fp);
}