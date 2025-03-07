#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define SIZE 34

//recur函数的功能：递归调用，找出质数（筛选）
void recur(int p[2])
{
    int primes, nums;
    int p1[2];

    close(0);    // 关闭标准输入
    dup(p[0]);   // 复制管道的读端到标准输入
    close(p[0]); // 关闭管道的读端
    close(p[1]); // 关闭管道的写端

    if (read(0, &primes, 4))
    {
        printf("prime %d\n", primes); // 打印由父进程传来的第一个质数

        pipe(p1); // 创建新的管道

        if (fork() == 0)//创建子进程
        {
            recur(p1); // 递归调用
        }else{
            while(read(0, &nums, 4))
            {
                if(nums % primes != 0)//将符合条件的数字传给子进程
                {
                    write(p1[1], &nums, 4); // 将不是primes的倍数的数写入管道
                }
            }
            close(p1[1]);//关闭写端
            close(0);//关闭标准输入
            wait(0);//等待子进程结束
        }
    }else{
        close(0);
    }
    exit(0);
}

int main()
{
    int p[2];
    pipe(p);
    for (int i = 2; i <= SIZE; i++)
    {
        write(p[1], &i, 4); // 将2到SIZE(34)写入管道
    }
    if(fork()==0)//创建子进程
    {
        recur(p);
    }else{
        close(p[1]);
        wait(0);
    }
exit(0);
}