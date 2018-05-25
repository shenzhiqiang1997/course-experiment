#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include<sys/types.h>
#include<sys/wait.h>
int main(void){
	char message1[255] = "Child process 1 is sending a message!";
	char message2[255] = "Child process 2 is sending a message!";
	int fd[2];
	// 创建管道
	pipe(fd);

	// 创建子进程1
	pid_t p1 = fork();
	if(p1 == 0){
		// 关闭管道读端
		close(fd[0]);
		// 向管道写数据
		write(fd[1],message1,sizeof(message1));
		return 0;
	}

	// 创建子进程2
	pid_t p2 = fork();
	if(p2 == 0){
		waitpid(p1,NULL,0);
		// 关闭管道读端
		close(fd[0]);
		// 向管道写数据
		write(fd[1],message2,sizeof(message1));
		return 0;
	}

	// 等待子进程1和2结束
	waitpid(p1,NULL,0);
	waitpid(p2,NULL,0);
 
	// 关闭管道写端
	close(fd[1]);
	// 从管道读数据
	char message [255];
	read(fd[0],message,sizeof(message));
	printf("%s\n",message);
	read(fd[0],message,sizeof(message));
	printf("%s\n",message);
}