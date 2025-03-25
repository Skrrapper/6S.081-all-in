// user/primes.c
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define SIZE 34

void recur(int p[2]) {
    int primes, nums;
    int p1[2];

    close(0); // 0的复用
    dup(p[0]);
    close(p[0]);
    close(p[1]);

    if (read(0, &primes, 4)) {
        printf("prime %d\n", primes); // 打印由父进程传来的第一个数字

        pipe(p1);
        if (fork() == 0) {
            recur(p1); // 由子进程筛选下一批质数
        } // 思考：考虑子进程已经在读、但是父进程还没写完的情况，子进程会等吗，还是报错呢？
        else {
            while (read(0, &nums, 4)) { // 从父进程读取数据
                if (nums % primes != 0) { // 筛查，将符合条件的数字传给子进程
                    write(p1[1], &nums, 4);
                }
            }
            close(p1[1]);
            close(0);
            wait(0);
        }
    } else {
        close(0); // 递归出口：若父进程无数据输入，则说明筛查完毕
    }
    exit(0);
}

int main() {
    int p[2];
    pipe(p);
    for (int i = 2; i < SIZE + 2; ++i) {
        write(p[1], &i, 4);
    }
    if (fork() == 0) {
        recur(p);
    } else {
        close(p[1]);
        wait(0);
    }
    exit(0);
}
