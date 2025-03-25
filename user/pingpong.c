// user/pingpong.c
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
    int p1[2], p2[2];
    pipe(p1), pipe(p2);
    char buf[5]; // 用于保存从管道读取的信息
    int size;
    int pid = fork();
    if (pid == 0) {
        //读取父进程传过来的信息
        close(p1[1]); // 关闭管道1的写端
        if ((size = read(p1[0], buf, sizeof buf)) > 0) { // 从管道1读取不大于buf个字节的数据到buf
            printf("%d: received ", getpid());
            write(1, buf, size);
        } else {
            printf("%d: receive failed\n", getpid());
        }
        //向父进程写信息
        close(p2[0]); // 关闭管道2的读端
        write(p2[1], "pong\n", 5); // 向管道2写从“pong\n"开始的不大于5个字节的数据
        exit(0);
    } else if (pid > 0) {
        //向子进程写信息
        close(p1[0]);
        write(p1[1], "ping\n", 5);

        wait(0);
		//读取子进程传过来的信息
        close(p2[1]);
        if ((size = read(p2[0], buf, sizeof buf)) > 0) {
            printf("%d: received ", getpid());
            write(1, buf, size);
        } else {
            printf("%d: receive failed\n", getpid());
        }
    } else {
        printf("fork error\n");
    }
    exit(0);
}
