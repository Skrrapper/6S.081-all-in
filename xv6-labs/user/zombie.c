// Create a zombie process that
// must be reparented at exit.

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
//僵尸进程是指一个已经结束的进程，但是其父进程还没有调用wait()来获取其结束状态，此时的进程就是僵尸进程。
int
main(void)
{
  if(fork() > 0)
    sleep(5);  // Let child exit before parent.
  exit(0);
}
