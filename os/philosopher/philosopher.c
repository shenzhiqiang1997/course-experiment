#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <semaphore.h>

pthread_mutex_t chopstick[6];
sem_t sem;

void* eat_and_think(void* arg){
	// 获取哲学家编号
	int i=*(int*)arg;
	int left=i;
	int right=right=(i+1)%5;
	while(1){
		// 只允许同时有4个哲学家进行筷子的获取
		sem_wait(&sem);
		// 获取筷子
		pthread_mutex_lock(&chopstick[left]);
		pthread_mutex_lock(&chopstick[right]);

		// 吃饭
		printf("哲学家%d吃饭\n",i);
		sleep(1);

		// 释放筷子
		pthread_mutex_unlock(&chopstick[left]);
		pthread_mutex_unlock(&chopstick[right]);
		sem_post(&sem);

		// 思考
		printf("哲学家%d思考\n",i);
		sleep(3);
	}
}

int main(){
	pthread_t t0,t1,t2,t3,t4;
	// 初始化互斥量
	for(int i=0;i<6;i++){
		pthread_mutex_init(&chopstick[i],NULL);
	}
	sem_init(&sem,1,4);

	int i[5]={0,1,2,3,4};
	// 创建5个哲学家线程
	pthread_create(&t0,NULL,eat_and_think,&i[0]);
	pthread_create(&t1,NULL,eat_and_think,&i[1]);
	pthread_create(&t2,NULL,eat_and_think,&i[2]);
	pthread_create(&t3,NULL,eat_and_think,&i[3]);
	pthread_create(&t4,NULL,eat_and_think,&i[4]);

	// 等待5个哲学家线程结束
	pthread_join(t0,NULL);
	pthread_join(t1,NULL);
	pthread_join(t2,NULL);
	pthread_join(t3,NULL);
	pthread_join(t4,NULL);
}
