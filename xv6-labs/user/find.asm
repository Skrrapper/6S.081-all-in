
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <find>:
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

void find(char *path, char *name)
{
   0:	7111                	addi	sp,sp,-256
   2:	fd86                	sd	ra,248(sp)
   4:	f9a2                	sd	s0,240(sp)
   6:	f5a6                	sd	s1,232(sp)
   8:	f1ca                	sd	s2,224(sp)
   a:	edce                	sd	s3,216(sp)
   c:	e9d2                	sd	s4,208(sp)
   e:	e5d6                	sd	s5,200(sp)
  10:	e1da                	sd	s6,192(sp)
  12:	fd5e                	sd	s7,184(sp)
  14:	f962                	sd	s8,176(sp)
  16:	0200                	addi	s0,sp,256
  18:	892a                	mv	s2,a0
  1a:	89ae                	mv	s3,a1
    int fd, fd1;       // 文件描述符、
    struct dirent de;  // 目录项
    struct stat st;    // 文件属性

    // 如果文件描述符<0，则说明文件打开失败
    if ((fd = open(path, 0)) < 0)//这里的参数0表示以只读方式打开文件
  1c:	4581                	li	a1,0
  1e:	00000097          	auipc	ra,0x0
  22:	4bc080e7          	jalr	1212(ra) # 4da <open>
  26:	02054f63          	bltz	a0,64 <find+0x64>
  2a:	84aa                	mv	s1,a0
        fprintf(2, "find: cannot open %s\n", path);
        return;
    }

    // 如果文件属性获取失败，则文件打开失败
    if (fstat(fd, &st) < 0)
  2c:	f0840593          	addi	a1,s0,-248
  30:	00000097          	auipc	ra,0x0
  34:	4c2080e7          	jalr	1218(ra) # 4f2 <fstat>
  38:	04054163          	bltz	a0,7a <find+0x7a>
        fprintf(2, "find: cannot stat %s\n", path);
        close(fd);
        return;
    }

    switch (st.type)
  3c:	f1041783          	lh	a5,-240(s0)
  40:	0007869b          	sext.w	a3,a5
  44:	4705                	li	a4,1
  46:	04e68a63          	beq	a3,a4,9a <find+0x9a>
  4a:	4709                	li	a4,2
  4c:	16e69a63          	bne	a3,a4,1c0 <find+0x1c0>
    {
    case T_FILE:
        // 文件
        /* code */
        fprintf(2, "path error\n"); // 路径错误
  50:	00001597          	auipc	a1,0x1
  54:	99858593          	addi	a1,a1,-1640 # 9e8 <malloc+0x118>
  58:	4509                	li	a0,2
  5a:	00000097          	auipc	ra,0x0
  5e:	78a080e7          	jalr	1930(ra) # 7e4 <fprintf>
        return;
  62:	a2a5                	j	1ca <find+0x1ca>
        fprintf(2, "find: cannot open %s\n", path);
  64:	864a                	mv	a2,s2
  66:	00001597          	auipc	a1,0x1
  6a:	95258593          	addi	a1,a1,-1710 # 9b8 <malloc+0xe8>
  6e:	4509                	li	a0,2
  70:	00000097          	auipc	ra,0x0
  74:	774080e7          	jalr	1908(ra) # 7e4 <fprintf>
        return;
  78:	aa89                	j	1ca <find+0x1ca>
        fprintf(2, "find: cannot stat %s\n", path);
  7a:	864a                	mv	a2,s2
  7c:	00001597          	auipc	a1,0x1
  80:	95458593          	addi	a1,a1,-1708 # 9d0 <malloc+0x100>
  84:	4509                	li	a0,2
  86:	00000097          	auipc	ra,0x0
  8a:	75e080e7          	jalr	1886(ra) # 7e4 <fprintf>
        close(fd);
  8e:	8526                	mv	a0,s1
  90:	00000097          	auipc	ra,0x0
  94:	432080e7          	jalr	1074(ra) # 4c2 <close>
        return;
  98:	aa0d                	j	1ca <find+0x1ca>
    case T_DIR:
        // 目录
        strcpy(buf, path);     // 复制路径
  9a:	85ca                	mv	a1,s2
  9c:	f3040513          	addi	a0,s0,-208
  a0:	00000097          	auipc	ra,0x0
  a4:	184080e7          	jalr	388(ra) # 224 <strcpy>
        p = buf + strlen(buf); // 指针指向路径末尾
  a8:	f3040513          	addi	a0,s0,-208
  ac:	00000097          	auipc	ra,0x0
  b0:	1c0080e7          	jalr	448(ra) # 26c <strlen>
  b4:	1502                	slli	a0,a0,0x20
  b6:	9101                	srli	a0,a0,0x20
  b8:	f3040793          	addi	a5,s0,-208
  bc:	953e                	add	a0,a0,a5
        *p++ = '/';            // 路径末尾加上'/',表示这是个目录
  be:	00150b13          	addi	s6,a0,1
  c2:	02f00793          	li	a5,47
  c6:	00f50023          	sb	a5,0(a0)
        {
            { // 遍历搜索目录
                if (de.inum == 0)
                    continue; // 如果inum为0，则说明该目录为空
            }
            if (!strcmp(de.name, ".") || !strcmp(de.name, "..")) // 如果目录名为.或者..，则跳过
  ca:	00001a17          	auipc	s4,0x1
  ce:	92ea0a13          	addi	s4,s4,-1746 # 9f8 <malloc+0x128>
  d2:	f2240a93          	addi	s5,s0,-222
  d6:	8956                	mv	s2,s5
  d8:	00001b97          	auipc	s7,0x1
  dc:	928b8b93          	addi	s7,s7,-1752 # a00 <malloc+0x130>
        while (read(fd, &de, sizeof(de)) == sizeof(de))
  e0:	4641                	li	a2,16
  e2:	f2040593          	addi	a1,s0,-224
  e6:	8526                	mv	a0,s1
  e8:	00000097          	auipc	ra,0x0
  ec:	3ca080e7          	jalr	970(ra) # 4b2 <read>
  f0:	47c1                	li	a5,16
  f2:	0cf51763          	bne	a0,a5,1c0 <find+0x1c0>
                if (de.inum == 0)
  f6:	f2045783          	lhu	a5,-224(s0)
  fa:	d3fd                	beqz	a5,e0 <find+0xe0>
            if (!strcmp(de.name, ".") || !strcmp(de.name, "..")) // 如果目录名为.或者..，则跳过
  fc:	85d2                	mv	a1,s4
  fe:	854a                	mv	a0,s2
 100:	00000097          	auipc	ra,0x0
 104:	140080e7          	jalr	320(ra) # 240 <strcmp>
 108:	dd61                	beqz	a0,e0 <find+0xe0>
 10a:	85de                	mv	a1,s7
 10c:	854a                	mv	a0,s2
 10e:	00000097          	auipc	ra,0x0
 112:	132080e7          	jalr	306(ra) # 240 <strcmp>
 116:	d569                	beqz	a0,e0 <find+0xe0>

            {
                continue;
            }
            memmove(p, de.name, DIRSIZ); // 将目录名复制到p指向的位置
 118:	4639                	li	a2,14
 11a:	85d6                	mv	a1,s5
 11c:	855a                	mv	a0,s6
 11e:	00000097          	auipc	ra,0x0
 122:	2c6080e7          	jalr	710(ra) # 3e4 <memmove>
            if ((fd1 = open(buf, 0)) >= 0)
 126:	4581                	li	a1,0
 128:	f3040513          	addi	a0,s0,-208
 12c:	00000097          	auipc	ra,0x0
 130:	3ae080e7          	jalr	942(ra) # 4da <open>
 134:	8c2a                	mv	s8,a0
 136:	fa0545e3          	bltz	a0,e0 <find+0xe0>
            {
                if (fstat(fd1, &st) >= 0)
 13a:	f0840593          	addi	a1,s0,-248
 13e:	00000097          	auipc	ra,0x0
 142:	3b4080e7          	jalr	948(ra) # 4f2 <fstat>
 146:	f80549e3          	bltz	a0,d8 <find+0xd8>
                {
                    switch (st.type)
 14a:	f1041783          	lh	a5,-240(s0)
 14e:	0007869b          	sext.w	a3,a5
 152:	4709                	li	a4,2
 154:	02e68763          	beq	a3,a4,182 <find+0x182>
 158:	8736                	mv	a4,a3
 15a:	468d                	li	a3,3
 15c:	04d70c63          	beq	a4,a3,1b4 <find+0x1b4>
 160:	87ba                	mv	a5,a4
 162:	4705                	li	a4,1
 164:	f6e79ae3          	bne	a5,a4,d8 <find+0xd8>
                            printf("%s\n", buf); // 打印文件路径
                        }
                        close(fd1);
                        break;
                    case T_DIR:     // 如果是目录，就递归调用find函数，直到找到最终的目标文件名
                        close(fd1); // 关闭文件描述符
 168:	8562                	mv	a0,s8
 16a:	00000097          	auipc	ra,0x0
 16e:	358080e7          	jalr	856(ra) # 4c2 <close>
                        find(buf, name);
 172:	85ce                	mv	a1,s3
 174:	f3040513          	addi	a0,s0,-208
 178:	00000097          	auipc	ra,0x0
 17c:	e88080e7          	jalr	-376(ra) # 0 <find>
                        break;
 180:	bfa1                	j	d8 <find+0xd8>
                        if (!strcmp(de.name, name)) // 如果找到了文件，即目标文件名和文件名一致
 182:	85ce                	mv	a1,s3
 184:	f2240513          	addi	a0,s0,-222
 188:	00000097          	auipc	ra,0x0
 18c:	0b8080e7          	jalr	184(ra) # 240 <strcmp>
 190:	c519                	beqz	a0,19e <find+0x19e>
                        close(fd1);
 192:	8562                	mv	a0,s8
 194:	00000097          	auipc	ra,0x0
 198:	32e080e7          	jalr	814(ra) # 4c2 <close>
                        break;
 19c:	bf35                	j	d8 <find+0xd8>
                            printf("%s\n", buf); // 打印文件路径
 19e:	f3040593          	addi	a1,s0,-208
 1a2:	00001517          	auipc	a0,0x1
 1a6:	86650513          	addi	a0,a0,-1946 # a08 <malloc+0x138>
 1aa:	00000097          	auipc	ra,0x0
 1ae:	668080e7          	jalr	1640(ra) # 812 <printf>
 1b2:	b7c5                	j	192 <find+0x192>
                    case T_DEVICE://如果是设备文件，直接关闭文件描述符
                        close(fd1);
 1b4:	8562                	mv	a0,s8
 1b6:	00000097          	auipc	ra,0x0
 1ba:	30c080e7          	jalr	780(ra) # 4c2 <close>
                        break;           
 1be:	bf29                	j	d8 <find+0xd8>
                }
            }
        }
        break;
    }
    close(fd);
 1c0:	8526                	mv	a0,s1
 1c2:	00000097          	auipc	ra,0x0
 1c6:	300080e7          	jalr	768(ra) # 4c2 <close>
}
 1ca:	70ee                	ld	ra,248(sp)
 1cc:	744e                	ld	s0,240(sp)
 1ce:	74ae                	ld	s1,232(sp)
 1d0:	790e                	ld	s2,224(sp)
 1d2:	69ee                	ld	s3,216(sp)
 1d4:	6a4e                	ld	s4,208(sp)
 1d6:	6aae                	ld	s5,200(sp)
 1d8:	6b0e                	ld	s6,192(sp)
 1da:	7bea                	ld	s7,184(sp)
 1dc:	7c4a                	ld	s8,176(sp)
 1de:	6111                	addi	sp,sp,256
 1e0:	8082                	ret

00000000000001e2 <main>:

int main(int argc, char *argv[])
{
 1e2:	1141                	addi	sp,sp,-16
 1e4:	e406                	sd	ra,8(sp)
 1e6:	e022                	sd	s0,0(sp)
 1e8:	0800                	addi	s0,sp,16
    if (argc != 3)
 1ea:	470d                	li	a4,3
 1ec:	02e50063          	beq	a0,a4,20c <main+0x2a>
    {
        fprintf(2, "Usage: find path name\n");
 1f0:	00001597          	auipc	a1,0x1
 1f4:	82058593          	addi	a1,a1,-2016 # a10 <malloc+0x140>
 1f8:	4509                	li	a0,2
 1fa:	00000097          	auipc	ra,0x0
 1fe:	5ea080e7          	jalr	1514(ra) # 7e4 <fprintf>
        exit(1);
 202:	4505                	li	a0,1
 204:	00000097          	auipc	ra,0x0
 208:	296080e7          	jalr	662(ra) # 49a <exit>
 20c:	87ae                	mv	a5,a1
    }
    find(argv[1], argv[2]);
 20e:	698c                	ld	a1,16(a1)
 210:	6788                	ld	a0,8(a5)
 212:	00000097          	auipc	ra,0x0
 216:	dee080e7          	jalr	-530(ra) # 0 <find>
    exit(0);
 21a:	4501                	li	a0,0
 21c:	00000097          	auipc	ra,0x0
 220:	27e080e7          	jalr	638(ra) # 49a <exit>

0000000000000224 <strcpy>:
#include "user/user.h"

//将字符串t复制到字符串s中，并返回s的起始地址
char*
strcpy(char *s, const char *t)
{
 224:	1141                	addi	sp,sp,-16
 226:	e422                	sd	s0,8(sp)
 228:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 22a:	87aa                	mv	a5,a0
 22c:	0585                	addi	a1,a1,1
 22e:	0785                	addi	a5,a5,1
 230:	fff5c703          	lbu	a4,-1(a1)
 234:	fee78fa3          	sb	a4,-1(a5)
 238:	fb75                	bnez	a4,22c <strcpy+0x8>
    ;
  return os;
}
 23a:	6422                	ld	s0,8(sp)
 23c:	0141                	addi	sp,sp,16
 23e:	8082                	ret

0000000000000240 <strcmp>:

//比较字符串p和q，返回差值
int
strcmp(const char *p, const char *q)
{
 240:	1141                	addi	sp,sp,-16
 242:	e422                	sd	s0,8(sp)
 244:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 246:	00054783          	lbu	a5,0(a0)
 24a:	cb91                	beqz	a5,25e <strcmp+0x1e>
 24c:	0005c703          	lbu	a4,0(a1)
 250:	00f71763          	bne	a4,a5,25e <strcmp+0x1e>
    p++, q++;
 254:	0505                	addi	a0,a0,1
 256:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 258:	00054783          	lbu	a5,0(a0)
 25c:	fbe5                	bnez	a5,24c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 25e:	0005c503          	lbu	a0,0(a1)
}
 262:	40a7853b          	subw	a0,a5,a0
 266:	6422                	ld	s0,8(sp)
 268:	0141                	addi	sp,sp,16
 26a:	8082                	ret

000000000000026c <strlen>:

//返回字符串s的长度n
uint
strlen(const char *s)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e422                	sd	s0,8(sp)
 270:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 272:	00054783          	lbu	a5,0(a0)
 276:	cf91                	beqz	a5,292 <strlen+0x26>
 278:	0505                	addi	a0,a0,1
 27a:	87aa                	mv	a5,a0
 27c:	4685                	li	a3,1
 27e:	9e89                	subw	a3,a3,a0
 280:	00f6853b          	addw	a0,a3,a5
 284:	0785                	addi	a5,a5,1
 286:	fff7c703          	lbu	a4,-1(a5)
 28a:	fb7d                	bnez	a4,280 <strlen+0x14>
    ;
  return n;
}
 28c:	6422                	ld	s0,8(sp)
 28e:	0141                	addi	sp,sp,16
 290:	8082                	ret
  for(n = 0; s[n]; n++)
 292:	4501                	li	a0,0
 294:	bfe5                	j	28c <strlen+0x20>

0000000000000296 <memset>:

//将前n个字节都设置为c
void*
memset(void *dst, int c, uint n)
{
 296:	1141                	addi	sp,sp,-16
 298:	e422                	sd	s0,8(sp)
 29a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;//强制转换成char类型
  int i;
  for(i = 0; i < n; i++){
 29c:	ce09                	beqz	a2,2b6 <memset+0x20>
 29e:	87aa                	mv	a5,a0
 2a0:	fff6071b          	addiw	a4,a2,-1
 2a4:	1702                	slli	a4,a4,0x20
 2a6:	9301                	srli	a4,a4,0x20
 2a8:	0705                	addi	a4,a4,1
 2aa:	972a                	add	a4,a4,a0
    cdst[i] = c;
 2ac:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2b0:	0785                	addi	a5,a5,1
 2b2:	fee79de3          	bne	a5,a4,2ac <memset+0x16>
  }
  return dst;
}
 2b6:	6422                	ld	s0,8(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret

00000000000002bc <strchr>:

//查找字符c，并返回指向该字符的指针
char*
strchr(const char *s, char c)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e422                	sd	s0,8(sp)
 2c0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2c2:	00054783          	lbu	a5,0(a0)
 2c6:	cb99                	beqz	a5,2dc <strchr+0x20>
    if(*s == c)
 2c8:	00f58763          	beq	a1,a5,2d6 <strchr+0x1a>
  for(; *s; s++)
 2cc:	0505                	addi	a0,a0,1
 2ce:	00054783          	lbu	a5,0(a0)
 2d2:	fbfd                	bnez	a5,2c8 <strchr+0xc>
      return (char*)s;
  return 0;
 2d4:	4501                	li	a0,0
}
 2d6:	6422                	ld	s0,8(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret
  return 0;
 2dc:	4501                	li	a0,0
 2de:	bfe5                	j	2d6 <strchr+0x1a>

00000000000002e0 <gets>:

//
char*
gets(char *buf, int max)
{
 2e0:	711d                	addi	sp,sp,-96
 2e2:	ec86                	sd	ra,88(sp)
 2e4:	e8a2                	sd	s0,80(sp)
 2e6:	e4a6                	sd	s1,72(sp)
 2e8:	e0ca                	sd	s2,64(sp)
 2ea:	fc4e                	sd	s3,56(sp)
 2ec:	f852                	sd	s4,48(sp)
 2ee:	f456                	sd	s5,40(sp)
 2f0:	f05a                	sd	s6,32(sp)
 2f2:	ec5e                	sd	s7,24(sp)
 2f4:	1080                	addi	s0,sp,96
 2f6:	8baa                	mv	s7,a0
 2f8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2fa:	892a                	mv	s2,a0
 2fc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2fe:	4aa9                	li	s5,10
 300:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 302:	89a6                	mv	s3,s1
 304:	2485                	addiw	s1,s1,1
 306:	0344d863          	bge	s1,s4,336 <gets+0x56>
    cc = read(0, &c, 1);
 30a:	4605                	li	a2,1
 30c:	faf40593          	addi	a1,s0,-81
 310:	4501                	li	a0,0
 312:	00000097          	auipc	ra,0x0
 316:	1a0080e7          	jalr	416(ra) # 4b2 <read>
    if(cc < 1)
 31a:	00a05e63          	blez	a0,336 <gets+0x56>
    buf[i++] = c;
 31e:	faf44783          	lbu	a5,-81(s0)
 322:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 326:	01578763          	beq	a5,s5,334 <gets+0x54>
 32a:	0905                	addi	s2,s2,1
 32c:	fd679be3          	bne	a5,s6,302 <gets+0x22>
  for(i=0; i+1 < max; ){
 330:	89a6                	mv	s3,s1
 332:	a011                	j	336 <gets+0x56>
 334:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 336:	99de                	add	s3,s3,s7
 338:	00098023          	sb	zero,0(s3)
  return buf;
}
 33c:	855e                	mv	a0,s7
 33e:	60e6                	ld	ra,88(sp)
 340:	6446                	ld	s0,80(sp)
 342:	64a6                	ld	s1,72(sp)
 344:	6906                	ld	s2,64(sp)
 346:	79e2                	ld	s3,56(sp)
 348:	7a42                	ld	s4,48(sp)
 34a:	7aa2                	ld	s5,40(sp)
 34c:	7b02                	ld	s6,32(sp)
 34e:	6be2                	ld	s7,24(sp)
 350:	6125                	addi	sp,sp,96
 352:	8082                	ret

0000000000000354 <stat>:

int
stat(const char *n, struct stat *st)
{
 354:	1101                	addi	sp,sp,-32
 356:	ec06                	sd	ra,24(sp)
 358:	e822                	sd	s0,16(sp)
 35a:	e426                	sd	s1,8(sp)
 35c:	e04a                	sd	s2,0(sp)
 35e:	1000                	addi	s0,sp,32
 360:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 362:	4581                	li	a1,0
 364:	00000097          	auipc	ra,0x0
 368:	176080e7          	jalr	374(ra) # 4da <open>
  if(fd < 0)
 36c:	02054563          	bltz	a0,396 <stat+0x42>
 370:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 372:	85ca                	mv	a1,s2
 374:	00000097          	auipc	ra,0x0
 378:	17e080e7          	jalr	382(ra) # 4f2 <fstat>
 37c:	892a                	mv	s2,a0
  close(fd);
 37e:	8526                	mv	a0,s1
 380:	00000097          	auipc	ra,0x0
 384:	142080e7          	jalr	322(ra) # 4c2 <close>
  return r;
}
 388:	854a                	mv	a0,s2
 38a:	60e2                	ld	ra,24(sp)
 38c:	6442                	ld	s0,16(sp)
 38e:	64a2                	ld	s1,8(sp)
 390:	6902                	ld	s2,0(sp)
 392:	6105                	addi	sp,sp,32
 394:	8082                	ret
    return -1;
 396:	597d                	li	s2,-1
 398:	bfc5                	j	388 <stat+0x34>

000000000000039a <atoi>:

int
atoi(const char *s)
{
 39a:	1141                	addi	sp,sp,-16
 39c:	e422                	sd	s0,8(sp)
 39e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3a0:	00054603          	lbu	a2,0(a0)
 3a4:	fd06079b          	addiw	a5,a2,-48
 3a8:	0ff7f793          	andi	a5,a5,255
 3ac:	4725                	li	a4,9
 3ae:	02f76963          	bltu	a4,a5,3e0 <atoi+0x46>
 3b2:	86aa                	mv	a3,a0
  n = 0;
 3b4:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3b6:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3b8:	0685                	addi	a3,a3,1
 3ba:	0025179b          	slliw	a5,a0,0x2
 3be:	9fa9                	addw	a5,a5,a0
 3c0:	0017979b          	slliw	a5,a5,0x1
 3c4:	9fb1                	addw	a5,a5,a2
 3c6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3ca:	0006c603          	lbu	a2,0(a3)
 3ce:	fd06071b          	addiw	a4,a2,-48
 3d2:	0ff77713          	andi	a4,a4,255
 3d6:	fee5f1e3          	bgeu	a1,a4,3b8 <atoi+0x1e>
  return n;
}
 3da:	6422                	ld	s0,8(sp)
 3dc:	0141                	addi	sp,sp,16
 3de:	8082                	ret
  n = 0;
 3e0:	4501                	li	a0,0
 3e2:	bfe5                	j	3da <atoi+0x40>

00000000000003e4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3e4:	1141                	addi	sp,sp,-16
 3e6:	e422                	sd	s0,8(sp)
 3e8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3ea:	02b57663          	bgeu	a0,a1,416 <memmove+0x32>
    while(n-- > 0)
 3ee:	02c05163          	blez	a2,410 <memmove+0x2c>
 3f2:	fff6079b          	addiw	a5,a2,-1
 3f6:	1782                	slli	a5,a5,0x20
 3f8:	9381                	srli	a5,a5,0x20
 3fa:	0785                	addi	a5,a5,1
 3fc:	97aa                	add	a5,a5,a0
  dst = vdst;
 3fe:	872a                	mv	a4,a0
      *dst++ = *src++;
 400:	0585                	addi	a1,a1,1
 402:	0705                	addi	a4,a4,1
 404:	fff5c683          	lbu	a3,-1(a1)
 408:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 40c:	fee79ae3          	bne	a5,a4,400 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 410:	6422                	ld	s0,8(sp)
 412:	0141                	addi	sp,sp,16
 414:	8082                	ret
    dst += n;
 416:	00c50733          	add	a4,a0,a2
    src += n;
 41a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 41c:	fec05ae3          	blez	a2,410 <memmove+0x2c>
 420:	fff6079b          	addiw	a5,a2,-1
 424:	1782                	slli	a5,a5,0x20
 426:	9381                	srli	a5,a5,0x20
 428:	fff7c793          	not	a5,a5
 42c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 42e:	15fd                	addi	a1,a1,-1
 430:	177d                	addi	a4,a4,-1
 432:	0005c683          	lbu	a3,0(a1)
 436:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 43a:	fee79ae3          	bne	a5,a4,42e <memmove+0x4a>
 43e:	bfc9                	j	410 <memmove+0x2c>

0000000000000440 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 440:	1141                	addi	sp,sp,-16
 442:	e422                	sd	s0,8(sp)
 444:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 446:	ca05                	beqz	a2,476 <memcmp+0x36>
 448:	fff6069b          	addiw	a3,a2,-1
 44c:	1682                	slli	a3,a3,0x20
 44e:	9281                	srli	a3,a3,0x20
 450:	0685                	addi	a3,a3,1
 452:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 454:	00054783          	lbu	a5,0(a0)
 458:	0005c703          	lbu	a4,0(a1)
 45c:	00e79863          	bne	a5,a4,46c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 460:	0505                	addi	a0,a0,1
    p2++;
 462:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 464:	fed518e3          	bne	a0,a3,454 <memcmp+0x14>
  }
  return 0;
 468:	4501                	li	a0,0
 46a:	a019                	j	470 <memcmp+0x30>
      return *p1 - *p2;
 46c:	40e7853b          	subw	a0,a5,a4
}
 470:	6422                	ld	s0,8(sp)
 472:	0141                	addi	sp,sp,16
 474:	8082                	ret
  return 0;
 476:	4501                	li	a0,0
 478:	bfe5                	j	470 <memcmp+0x30>

000000000000047a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 47a:	1141                	addi	sp,sp,-16
 47c:	e406                	sd	ra,8(sp)
 47e:	e022                	sd	s0,0(sp)
 480:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 482:	00000097          	auipc	ra,0x0
 486:	f62080e7          	jalr	-158(ra) # 3e4 <memmove>
}
 48a:	60a2                	ld	ra,8(sp)
 48c:	6402                	ld	s0,0(sp)
 48e:	0141                	addi	sp,sp,16
 490:	8082                	ret

0000000000000492 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 492:	4885                	li	a7,1
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <exit>:
.global exit
exit:
 li a7, SYS_exit
 49a:	4889                	li	a7,2
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4a2:	488d                	li	a7,3
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4aa:	4891                	li	a7,4
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <read>:
.global read
read:
 li a7, SYS_read
 4b2:	4895                	li	a7,5
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <write>:
.global write
write:
 li a7, SYS_write
 4ba:	48c1                	li	a7,16
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <close>:
.global close
close:
 li a7, SYS_close
 4c2:	48d5                	li	a7,21
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <kill>:
.global kill
kill:
 li a7, SYS_kill
 4ca:	4899                	li	a7,6
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4d2:	489d                	li	a7,7
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <open>:
.global open
open:
 li a7, SYS_open
 4da:	48bd                	li	a7,15
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4e2:	48c5                	li	a7,17
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4ea:	48c9                	li	a7,18
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4f2:	48a1                	li	a7,8
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <link>:
.global link
link:
 li a7, SYS_link
 4fa:	48cd                	li	a7,19
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 502:	48d1                	li	a7,20
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 50a:	48a5                	li	a7,9
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <dup>:
.global dup
dup:
 li a7, SYS_dup
 512:	48a9                	li	a7,10
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 51a:	48ad                	li	a7,11
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 522:	48b1                	li	a7,12
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 52a:	48b5                	li	a7,13
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 532:	48b9                	li	a7,14
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 53a:	1101                	addi	sp,sp,-32
 53c:	ec06                	sd	ra,24(sp)
 53e:	e822                	sd	s0,16(sp)
 540:	1000                	addi	s0,sp,32
 542:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 546:	4605                	li	a2,1
 548:	fef40593          	addi	a1,s0,-17
 54c:	00000097          	auipc	ra,0x0
 550:	f6e080e7          	jalr	-146(ra) # 4ba <write>
}
 554:	60e2                	ld	ra,24(sp)
 556:	6442                	ld	s0,16(sp)
 558:	6105                	addi	sp,sp,32
 55a:	8082                	ret

000000000000055c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 55c:	7139                	addi	sp,sp,-64
 55e:	fc06                	sd	ra,56(sp)
 560:	f822                	sd	s0,48(sp)
 562:	f426                	sd	s1,40(sp)
 564:	f04a                	sd	s2,32(sp)
 566:	ec4e                	sd	s3,24(sp)
 568:	0080                	addi	s0,sp,64
 56a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 56c:	c299                	beqz	a3,572 <printint+0x16>
 56e:	0805c863          	bltz	a1,5fe <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 572:	2581                	sext.w	a1,a1
  neg = 0;
 574:	4881                	li	a7,0
 576:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 57a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 57c:	2601                	sext.w	a2,a2
 57e:	00000517          	auipc	a0,0x0
 582:	4b250513          	addi	a0,a0,1202 # a30 <digits>
 586:	883a                	mv	a6,a4
 588:	2705                	addiw	a4,a4,1
 58a:	02c5f7bb          	remuw	a5,a1,a2
 58e:	1782                	slli	a5,a5,0x20
 590:	9381                	srli	a5,a5,0x20
 592:	97aa                	add	a5,a5,a0
 594:	0007c783          	lbu	a5,0(a5)
 598:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 59c:	0005879b          	sext.w	a5,a1
 5a0:	02c5d5bb          	divuw	a1,a1,a2
 5a4:	0685                	addi	a3,a3,1
 5a6:	fec7f0e3          	bgeu	a5,a2,586 <printint+0x2a>
  if(neg)
 5aa:	00088b63          	beqz	a7,5c0 <printint+0x64>
    buf[i++] = '-';
 5ae:	fd040793          	addi	a5,s0,-48
 5b2:	973e                	add	a4,a4,a5
 5b4:	02d00793          	li	a5,45
 5b8:	fef70823          	sb	a5,-16(a4)
 5bc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5c0:	02e05863          	blez	a4,5f0 <printint+0x94>
 5c4:	fc040793          	addi	a5,s0,-64
 5c8:	00e78933          	add	s2,a5,a4
 5cc:	fff78993          	addi	s3,a5,-1
 5d0:	99ba                	add	s3,s3,a4
 5d2:	377d                	addiw	a4,a4,-1
 5d4:	1702                	slli	a4,a4,0x20
 5d6:	9301                	srli	a4,a4,0x20
 5d8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5dc:	fff94583          	lbu	a1,-1(s2)
 5e0:	8526                	mv	a0,s1
 5e2:	00000097          	auipc	ra,0x0
 5e6:	f58080e7          	jalr	-168(ra) # 53a <putc>
  while(--i >= 0)
 5ea:	197d                	addi	s2,s2,-1
 5ec:	ff3918e3          	bne	s2,s3,5dc <printint+0x80>
}
 5f0:	70e2                	ld	ra,56(sp)
 5f2:	7442                	ld	s0,48(sp)
 5f4:	74a2                	ld	s1,40(sp)
 5f6:	7902                	ld	s2,32(sp)
 5f8:	69e2                	ld	s3,24(sp)
 5fa:	6121                	addi	sp,sp,64
 5fc:	8082                	ret
    x = -xx;
 5fe:	40b005bb          	negw	a1,a1
    neg = 1;
 602:	4885                	li	a7,1
    x = -xx;
 604:	bf8d                	j	576 <printint+0x1a>

0000000000000606 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 606:	7119                	addi	sp,sp,-128
 608:	fc86                	sd	ra,120(sp)
 60a:	f8a2                	sd	s0,112(sp)
 60c:	f4a6                	sd	s1,104(sp)
 60e:	f0ca                	sd	s2,96(sp)
 610:	ecce                	sd	s3,88(sp)
 612:	e8d2                	sd	s4,80(sp)
 614:	e4d6                	sd	s5,72(sp)
 616:	e0da                	sd	s6,64(sp)
 618:	fc5e                	sd	s7,56(sp)
 61a:	f862                	sd	s8,48(sp)
 61c:	f466                	sd	s9,40(sp)
 61e:	f06a                	sd	s10,32(sp)
 620:	ec6e                	sd	s11,24(sp)
 622:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 624:	0005c903          	lbu	s2,0(a1)
 628:	18090f63          	beqz	s2,7c6 <vprintf+0x1c0>
 62c:	8aaa                	mv	s5,a0
 62e:	8b32                	mv	s6,a2
 630:	00158493          	addi	s1,a1,1
  state = 0;
 634:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 636:	02500a13          	li	s4,37
      if(c == 'd'){
 63a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 63e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 642:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 646:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 64a:	00000b97          	auipc	s7,0x0
 64e:	3e6b8b93          	addi	s7,s7,998 # a30 <digits>
 652:	a839                	j	670 <vprintf+0x6a>
        putc(fd, c);
 654:	85ca                	mv	a1,s2
 656:	8556                	mv	a0,s5
 658:	00000097          	auipc	ra,0x0
 65c:	ee2080e7          	jalr	-286(ra) # 53a <putc>
 660:	a019                	j	666 <vprintf+0x60>
    } else if(state == '%'){
 662:	01498f63          	beq	s3,s4,680 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 666:	0485                	addi	s1,s1,1
 668:	fff4c903          	lbu	s2,-1(s1)
 66c:	14090d63          	beqz	s2,7c6 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 670:	0009079b          	sext.w	a5,s2
    if(state == 0){
 674:	fe0997e3          	bnez	s3,662 <vprintf+0x5c>
      if(c == '%'){
 678:	fd479ee3          	bne	a5,s4,654 <vprintf+0x4e>
        state = '%';
 67c:	89be                	mv	s3,a5
 67e:	b7e5                	j	666 <vprintf+0x60>
      if(c == 'd'){
 680:	05878063          	beq	a5,s8,6c0 <vprintf+0xba>
      } else if(c == 'l') {
 684:	05978c63          	beq	a5,s9,6dc <vprintf+0xd6>
      } else if(c == 'x') {
 688:	07a78863          	beq	a5,s10,6f8 <vprintf+0xf2>
      } else if(c == 'p') {
 68c:	09b78463          	beq	a5,s11,714 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 690:	07300713          	li	a4,115
 694:	0ce78663          	beq	a5,a4,760 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 698:	06300713          	li	a4,99
 69c:	0ee78e63          	beq	a5,a4,798 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6a0:	11478863          	beq	a5,s4,7b0 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6a4:	85d2                	mv	a1,s4
 6a6:	8556                	mv	a0,s5
 6a8:	00000097          	auipc	ra,0x0
 6ac:	e92080e7          	jalr	-366(ra) # 53a <putc>
        putc(fd, c);
 6b0:	85ca                	mv	a1,s2
 6b2:	8556                	mv	a0,s5
 6b4:	00000097          	auipc	ra,0x0
 6b8:	e86080e7          	jalr	-378(ra) # 53a <putc>
      }
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	b765                	j	666 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6c0:	008b0913          	addi	s2,s6,8
 6c4:	4685                	li	a3,1
 6c6:	4629                	li	a2,10
 6c8:	000b2583          	lw	a1,0(s6)
 6cc:	8556                	mv	a0,s5
 6ce:	00000097          	auipc	ra,0x0
 6d2:	e8e080e7          	jalr	-370(ra) # 55c <printint>
 6d6:	8b4a                	mv	s6,s2
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	b771                	j	666 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6dc:	008b0913          	addi	s2,s6,8
 6e0:	4681                	li	a3,0
 6e2:	4629                	li	a2,10
 6e4:	000b2583          	lw	a1,0(s6)
 6e8:	8556                	mv	a0,s5
 6ea:	00000097          	auipc	ra,0x0
 6ee:	e72080e7          	jalr	-398(ra) # 55c <printint>
 6f2:	8b4a                	mv	s6,s2
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	bf85                	j	666 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6f8:	008b0913          	addi	s2,s6,8
 6fc:	4681                	li	a3,0
 6fe:	4641                	li	a2,16
 700:	000b2583          	lw	a1,0(s6)
 704:	8556                	mv	a0,s5
 706:	00000097          	auipc	ra,0x0
 70a:	e56080e7          	jalr	-426(ra) # 55c <printint>
 70e:	8b4a                	mv	s6,s2
      state = 0;
 710:	4981                	li	s3,0
 712:	bf91                	j	666 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 714:	008b0793          	addi	a5,s6,8
 718:	f8f43423          	sd	a5,-120(s0)
 71c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 720:	03000593          	li	a1,48
 724:	8556                	mv	a0,s5
 726:	00000097          	auipc	ra,0x0
 72a:	e14080e7          	jalr	-492(ra) # 53a <putc>
  putc(fd, 'x');
 72e:	85ea                	mv	a1,s10
 730:	8556                	mv	a0,s5
 732:	00000097          	auipc	ra,0x0
 736:	e08080e7          	jalr	-504(ra) # 53a <putc>
 73a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 73c:	03c9d793          	srli	a5,s3,0x3c
 740:	97de                	add	a5,a5,s7
 742:	0007c583          	lbu	a1,0(a5)
 746:	8556                	mv	a0,s5
 748:	00000097          	auipc	ra,0x0
 74c:	df2080e7          	jalr	-526(ra) # 53a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 750:	0992                	slli	s3,s3,0x4
 752:	397d                	addiw	s2,s2,-1
 754:	fe0914e3          	bnez	s2,73c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 758:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 75c:	4981                	li	s3,0
 75e:	b721                	j	666 <vprintf+0x60>
        s = va_arg(ap, char*);
 760:	008b0993          	addi	s3,s6,8
 764:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 768:	02090163          	beqz	s2,78a <vprintf+0x184>
        while(*s != 0){
 76c:	00094583          	lbu	a1,0(s2)
 770:	c9a1                	beqz	a1,7c0 <vprintf+0x1ba>
          putc(fd, *s);
 772:	8556                	mv	a0,s5
 774:	00000097          	auipc	ra,0x0
 778:	dc6080e7          	jalr	-570(ra) # 53a <putc>
          s++;
 77c:	0905                	addi	s2,s2,1
        while(*s != 0){
 77e:	00094583          	lbu	a1,0(s2)
 782:	f9e5                	bnez	a1,772 <vprintf+0x16c>
        s = va_arg(ap, char*);
 784:	8b4e                	mv	s6,s3
      state = 0;
 786:	4981                	li	s3,0
 788:	bdf9                	j	666 <vprintf+0x60>
          s = "(null)";
 78a:	00000917          	auipc	s2,0x0
 78e:	29e90913          	addi	s2,s2,670 # a28 <malloc+0x158>
        while(*s != 0){
 792:	02800593          	li	a1,40
 796:	bff1                	j	772 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 798:	008b0913          	addi	s2,s6,8
 79c:	000b4583          	lbu	a1,0(s6)
 7a0:	8556                	mv	a0,s5
 7a2:	00000097          	auipc	ra,0x0
 7a6:	d98080e7          	jalr	-616(ra) # 53a <putc>
 7aa:	8b4a                	mv	s6,s2
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	bd65                	j	666 <vprintf+0x60>
        putc(fd, c);
 7b0:	85d2                	mv	a1,s4
 7b2:	8556                	mv	a0,s5
 7b4:	00000097          	auipc	ra,0x0
 7b8:	d86080e7          	jalr	-634(ra) # 53a <putc>
      state = 0;
 7bc:	4981                	li	s3,0
 7be:	b565                	j	666 <vprintf+0x60>
        s = va_arg(ap, char*);
 7c0:	8b4e                	mv	s6,s3
      state = 0;
 7c2:	4981                	li	s3,0
 7c4:	b54d                	j	666 <vprintf+0x60>
    }
  }
}
 7c6:	70e6                	ld	ra,120(sp)
 7c8:	7446                	ld	s0,112(sp)
 7ca:	74a6                	ld	s1,104(sp)
 7cc:	7906                	ld	s2,96(sp)
 7ce:	69e6                	ld	s3,88(sp)
 7d0:	6a46                	ld	s4,80(sp)
 7d2:	6aa6                	ld	s5,72(sp)
 7d4:	6b06                	ld	s6,64(sp)
 7d6:	7be2                	ld	s7,56(sp)
 7d8:	7c42                	ld	s8,48(sp)
 7da:	7ca2                	ld	s9,40(sp)
 7dc:	7d02                	ld	s10,32(sp)
 7de:	6de2                	ld	s11,24(sp)
 7e0:	6109                	addi	sp,sp,128
 7e2:	8082                	ret

00000000000007e4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7e4:	715d                	addi	sp,sp,-80
 7e6:	ec06                	sd	ra,24(sp)
 7e8:	e822                	sd	s0,16(sp)
 7ea:	1000                	addi	s0,sp,32
 7ec:	e010                	sd	a2,0(s0)
 7ee:	e414                	sd	a3,8(s0)
 7f0:	e818                	sd	a4,16(s0)
 7f2:	ec1c                	sd	a5,24(s0)
 7f4:	03043023          	sd	a6,32(s0)
 7f8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7fc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 800:	8622                	mv	a2,s0
 802:	00000097          	auipc	ra,0x0
 806:	e04080e7          	jalr	-508(ra) # 606 <vprintf>
}
 80a:	60e2                	ld	ra,24(sp)
 80c:	6442                	ld	s0,16(sp)
 80e:	6161                	addi	sp,sp,80
 810:	8082                	ret

0000000000000812 <printf>:

void
printf(const char *fmt, ...)
{
 812:	711d                	addi	sp,sp,-96
 814:	ec06                	sd	ra,24(sp)
 816:	e822                	sd	s0,16(sp)
 818:	1000                	addi	s0,sp,32
 81a:	e40c                	sd	a1,8(s0)
 81c:	e810                	sd	a2,16(s0)
 81e:	ec14                	sd	a3,24(s0)
 820:	f018                	sd	a4,32(s0)
 822:	f41c                	sd	a5,40(s0)
 824:	03043823          	sd	a6,48(s0)
 828:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 82c:	00840613          	addi	a2,s0,8
 830:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 834:	85aa                	mv	a1,a0
 836:	4505                	li	a0,1
 838:	00000097          	auipc	ra,0x0
 83c:	dce080e7          	jalr	-562(ra) # 606 <vprintf>
}
 840:	60e2                	ld	ra,24(sp)
 842:	6442                	ld	s0,16(sp)
 844:	6125                	addi	sp,sp,96
 846:	8082                	ret

0000000000000848 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 848:	1141                	addi	sp,sp,-16
 84a:	e422                	sd	s0,8(sp)
 84c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 84e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 852:	00000797          	auipc	a5,0x0
 856:	1f67b783          	ld	a5,502(a5) # a48 <freep>
 85a:	a805                	j	88a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 85c:	4618                	lw	a4,8(a2)
 85e:	9db9                	addw	a1,a1,a4
 860:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 864:	6398                	ld	a4,0(a5)
 866:	6318                	ld	a4,0(a4)
 868:	fee53823          	sd	a4,-16(a0)
 86c:	a091                	j	8b0 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 86e:	ff852703          	lw	a4,-8(a0)
 872:	9e39                	addw	a2,a2,a4
 874:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 876:	ff053703          	ld	a4,-16(a0)
 87a:	e398                	sd	a4,0(a5)
 87c:	a099                	j	8c2 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 87e:	6398                	ld	a4,0(a5)
 880:	00e7e463          	bltu	a5,a4,888 <free+0x40>
 884:	00e6ea63          	bltu	a3,a4,898 <free+0x50>
{
 888:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 88a:	fed7fae3          	bgeu	a5,a3,87e <free+0x36>
 88e:	6398                	ld	a4,0(a5)
 890:	00e6e463          	bltu	a3,a4,898 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 894:	fee7eae3          	bltu	a5,a4,888 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 898:	ff852583          	lw	a1,-8(a0)
 89c:	6390                	ld	a2,0(a5)
 89e:	02059713          	slli	a4,a1,0x20
 8a2:	9301                	srli	a4,a4,0x20
 8a4:	0712                	slli	a4,a4,0x4
 8a6:	9736                	add	a4,a4,a3
 8a8:	fae60ae3          	beq	a2,a4,85c <free+0x14>
    bp->s.ptr = p->s.ptr;
 8ac:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8b0:	4790                	lw	a2,8(a5)
 8b2:	02061713          	slli	a4,a2,0x20
 8b6:	9301                	srli	a4,a4,0x20
 8b8:	0712                	slli	a4,a4,0x4
 8ba:	973e                	add	a4,a4,a5
 8bc:	fae689e3          	beq	a3,a4,86e <free+0x26>
  } else
    p->s.ptr = bp;
 8c0:	e394                	sd	a3,0(a5)
  freep = p;
 8c2:	00000717          	auipc	a4,0x0
 8c6:	18f73323          	sd	a5,390(a4) # a48 <freep>
}
 8ca:	6422                	ld	s0,8(sp)
 8cc:	0141                	addi	sp,sp,16
 8ce:	8082                	ret

00000000000008d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8d0:	7139                	addi	sp,sp,-64
 8d2:	fc06                	sd	ra,56(sp)
 8d4:	f822                	sd	s0,48(sp)
 8d6:	f426                	sd	s1,40(sp)
 8d8:	f04a                	sd	s2,32(sp)
 8da:	ec4e                	sd	s3,24(sp)
 8dc:	e852                	sd	s4,16(sp)
 8de:	e456                	sd	s5,8(sp)
 8e0:	e05a                	sd	s6,0(sp)
 8e2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e4:	02051493          	slli	s1,a0,0x20
 8e8:	9081                	srli	s1,s1,0x20
 8ea:	04bd                	addi	s1,s1,15
 8ec:	8091                	srli	s1,s1,0x4
 8ee:	0014899b          	addiw	s3,s1,1
 8f2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8f4:	00000517          	auipc	a0,0x0
 8f8:	15453503          	ld	a0,340(a0) # a48 <freep>
 8fc:	c515                	beqz	a0,928 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8fe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 900:	4798                	lw	a4,8(a5)
 902:	02977f63          	bgeu	a4,s1,940 <malloc+0x70>
 906:	8a4e                	mv	s4,s3
 908:	0009871b          	sext.w	a4,s3
 90c:	6685                	lui	a3,0x1
 90e:	00d77363          	bgeu	a4,a3,914 <malloc+0x44>
 912:	6a05                	lui	s4,0x1
 914:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 918:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 91c:	00000917          	auipc	s2,0x0
 920:	12c90913          	addi	s2,s2,300 # a48 <freep>
  if(p == (char*)-1)
 924:	5afd                	li	s5,-1
 926:	a88d                	j	998 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 928:	00000797          	auipc	a5,0x0
 92c:	12878793          	addi	a5,a5,296 # a50 <base>
 930:	00000717          	auipc	a4,0x0
 934:	10f73c23          	sd	a5,280(a4) # a48 <freep>
 938:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 93a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 93e:	b7e1                	j	906 <malloc+0x36>
      if(p->s.size == nunits)
 940:	02e48b63          	beq	s1,a4,976 <malloc+0xa6>
        p->s.size -= nunits;
 944:	4137073b          	subw	a4,a4,s3
 948:	c798                	sw	a4,8(a5)
        p += p->s.size;
 94a:	1702                	slli	a4,a4,0x20
 94c:	9301                	srli	a4,a4,0x20
 94e:	0712                	slli	a4,a4,0x4
 950:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 952:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 956:	00000717          	auipc	a4,0x0
 95a:	0ea73923          	sd	a0,242(a4) # a48 <freep>
      return (void*)(p + 1);
 95e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 962:	70e2                	ld	ra,56(sp)
 964:	7442                	ld	s0,48(sp)
 966:	74a2                	ld	s1,40(sp)
 968:	7902                	ld	s2,32(sp)
 96a:	69e2                	ld	s3,24(sp)
 96c:	6a42                	ld	s4,16(sp)
 96e:	6aa2                	ld	s5,8(sp)
 970:	6b02                	ld	s6,0(sp)
 972:	6121                	addi	sp,sp,64
 974:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 976:	6398                	ld	a4,0(a5)
 978:	e118                	sd	a4,0(a0)
 97a:	bff1                	j	956 <malloc+0x86>
  hp->s.size = nu;
 97c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 980:	0541                	addi	a0,a0,16
 982:	00000097          	auipc	ra,0x0
 986:	ec6080e7          	jalr	-314(ra) # 848 <free>
  return freep;
 98a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 98e:	d971                	beqz	a0,962 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 990:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 992:	4798                	lw	a4,8(a5)
 994:	fa9776e3          	bgeu	a4,s1,940 <malloc+0x70>
    if(p == freep)
 998:	00093703          	ld	a4,0(s2)
 99c:	853e                	mv	a0,a5
 99e:	fef719e3          	bne	a4,a5,990 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 9a2:	8552                	mv	a0,s4
 9a4:	00000097          	auipc	ra,0x0
 9a8:	b7e080e7          	jalr	-1154(ra) # 522 <sbrk>
  if(p == (char*)-1)
 9ac:	fd5518e3          	bne	a0,s5,97c <malloc+0xac>
        return 0;
 9b0:	4501                	li	a0,0
 9b2:	bf45                	j	962 <malloc+0x92>
