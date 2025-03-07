#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

void find(char *path, char *name)
{
    char buf[128], *p; // 缓冲区
    int fd, fd1;       // 文件描述符、
    struct dirent de;  // 目录项
    struct stat st;    // 文件属性

    // 如果文件描述符<0，则说明文件打开失败
    if ((fd = open(path, 0)) < 0)//这里的参数0表示以只读方式打开文件
    {
        fprintf(2, "find: cannot open %s\n", path);
        return;
    }

    // 如果文件属性获取失败，则文件打开失败
    if (fstat(fd, &st) < 0)
    {
        fprintf(2, "find: cannot stat %s\n", path);
        close(fd);
        return;
    }

    switch (st.type)
    {
    case T_FILE:
        // 文件
        /* code */
        fprintf(2, "path error\n"); // 路径错误
        return;
    case T_DIR:
        // 目录
        strcpy(buf, path);     // 复制路径
        p = buf + strlen(buf); // 指针指向路径末尾
        *p++ = '/';            // 路径末尾加上'/',表示这是个目录
        while (read(fd, &de, sizeof(de)) == sizeof(de))
        {
            { // 遍历搜索目录
                if (de.inum == 0)
                    continue; // 如果inum为0，则说明该目录为空
            }
            if (!strcmp(de.name, ".") || !strcmp(de.name, "..")) // 如果目录名为.或者..，则跳过

            {
                continue;
            }
            memmove(p, de.name, DIRSIZ); // 将目录名复制到p指向的位置
            if ((fd1 = open(buf, 0)) >= 0)
            {
                if (fstat(fd1, &st) >= 0)
                {
                    switch (st.type)
                    {
                    case T_FILE:                    // 如果是文件，进行文件路径打印
                        if (!strcmp(de.name, name)) // 如果找到了文件，即目标文件名和文件名一致
                        {
                            printf("%s\n", buf); // 打印文件路径
                        }
                        close(fd1);
                        break;
                    case T_DIR:     // 如果是目录，就递归调用find函数，直到找到最终的目标文件名
                        close(fd1); // 关闭文件描述符
                        find(buf, name);
                        break;
                    case T_DEVICE://如果是设备文件，直接关闭文件描述符
                        close(fd1);
                        break;           
                    }
                }
            }
        }
        break;
    }
    close(fd);
}

int main(int argc, char *argv[])
{
    if (argc != 3)
    {
        fprintf(2, "Usage: find path name\n");
        exit(1);
    }
    find(argv[1], argv[2]);
    exit(0);
}