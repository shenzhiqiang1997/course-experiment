#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/ipc.h>
#include <sys/msg.h>
struct mymesg{
    long mytype;//消息类型，使用正数
    char mtext[255];//消息数据，长度可以自行定义
};

int main(void){
	// 创建消息队列
	msgget(1111,IPC_CREAT);

	// 创建子进程Server进程
	pid_t server = fork();
	if(server == 0){
		struct mymesg msg;
		msg.mytype = 1;
		itoa(getpid(),msg.mtext,10);
		msgsnd(1,&msg,sizeof(msg.mtext),0);	
		msg = msgrcv(2,&msg,sizeof(msg.mtext),2,0);
		printf("%s\n",msg.mtext);
		return 0;
	}

	// 创建子进程Client进程
	pid_t client = fork();
	if(client == 0){
		struct mymesg msg;
		msg.mytype = 2;
		itoa(getpid(),msg.mtext,10);
		msgsnd(2,&msg,sizeof(msg.mtext),0);	
		msg = msgrcv(1,&msg,sizeof(msg.mtext),1,0);
		printf("%s\n",msg.mtext);
		return 0;
	}

	// 等待server和client进程结束
	waitpid(server,NULL,0);
	waitpid(client,NULL,0);
 

}