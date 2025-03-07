
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <recur>:

#define SIZE 34

//recur函数的功能：递归调用，找出质数（筛选）
void recur(int p[2])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
    int primes, nums;
    int p1[2];

    close(0);    // 关闭标准输入
   c:	4501                	li	a0,0
   e:	00000097          	auipc	ra,0x0
  12:	3f0080e7          	jalr	1008(ra) # 3fe <close>
    dup(p[0]);   // 复制管道的读端到标准输入
  16:	4088                	lw	a0,0(s1)
  18:	00000097          	auipc	ra,0x0
  1c:	436080e7          	jalr	1078(ra) # 44e <dup>
    close(p[0]); // 关闭管道的读端
  20:	4088                	lw	a0,0(s1)
  22:	00000097          	auipc	ra,0x0
  26:	3dc080e7          	jalr	988(ra) # 3fe <close>
    close(p[1]); // 关闭管道的写端
  2a:	40c8                	lw	a0,4(s1)
  2c:	00000097          	auipc	ra,0x0
  30:	3d2080e7          	jalr	978(ra) # 3fe <close>

    if (read(0, &primes, 4))
  34:	4611                	li	a2,4
  36:	fdc40593          	addi	a1,s0,-36
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	3b2080e7          	jalr	946(ra) # 3ee <read>
  44:	c559                	beqz	a0,d2 <recur+0xd2>
    {
        printf("prime %d\n", primes); // 打印由父进程传来的第一个质数
  46:	fdc42583          	lw	a1,-36(s0)
  4a:	00001517          	auipc	a0,0x1
  4e:	8a650513          	addi	a0,a0,-1882 # 8f0 <malloc+0xe4>
  52:	00000097          	auipc	ra,0x0
  56:	6fc080e7          	jalr	1788(ra) # 74e <printf>

        pipe(p1); // 创建新的管道
  5a:	fd040513          	addi	a0,s0,-48
  5e:	00000097          	auipc	ra,0x0
  62:	388080e7          	jalr	904(ra) # 3e6 <pipe>

        if (fork() == 0)//创建子进程
  66:	00000097          	auipc	ra,0x0
  6a:	368080e7          	jalr	872(ra) # 3ce <fork>
  6e:	c91d                	beqz	a0,a4 <recur+0xa4>
        {
            recur(p1); // 递归调用
        }else{
            while(read(0, &nums, 4))
  70:	4611                	li	a2,4
  72:	fd840593          	addi	a1,s0,-40
  76:	4501                	li	a0,0
  78:	00000097          	auipc	ra,0x0
  7c:	376080e7          	jalr	886(ra) # 3ee <read>
  80:	c905                	beqz	a0,b0 <recur+0xb0>
            {
                if(nums % primes != 0)//将符合条件的数字传给子进程
  82:	fd842783          	lw	a5,-40(s0)
  86:	fdc42703          	lw	a4,-36(s0)
  8a:	02e7e7bb          	remw	a5,a5,a4
  8e:	d3ed                	beqz	a5,70 <recur+0x70>
                {
                    write(p1[1], &nums, 4); // 将不是primes的倍数的数写入管道
  90:	4611                	li	a2,4
  92:	fd840593          	addi	a1,s0,-40
  96:	fd442503          	lw	a0,-44(s0)
  9a:	00000097          	auipc	ra,0x0
  9e:	35c080e7          	jalr	860(ra) # 3f6 <write>
  a2:	b7f9                	j	70 <recur+0x70>
            recur(p1); // 递归调用
  a4:	fd040513          	addi	a0,s0,-48
  a8:	00000097          	auipc	ra,0x0
  ac:	f58080e7          	jalr	-168(ra) # 0 <recur>
                }
            }
            close(p1[1]);//关闭写端
  b0:	fd442503          	lw	a0,-44(s0)
  b4:	00000097          	auipc	ra,0x0
  b8:	34a080e7          	jalr	842(ra) # 3fe <close>
            close(0);//关闭标准输入
  bc:	4501                	li	a0,0
  be:	00000097          	auipc	ra,0x0
  c2:	340080e7          	jalr	832(ra) # 3fe <close>
            wait(0);//等待子进程结束
  c6:	4501                	li	a0,0
  c8:	00000097          	auipc	ra,0x0
  cc:	316080e7          	jalr	790(ra) # 3de <wait>
  d0:	a031                	j	dc <recur+0xdc>
        }
    }else{
        close(0);
  d2:	4501                	li	a0,0
  d4:	00000097          	auipc	ra,0x0
  d8:	32a080e7          	jalr	810(ra) # 3fe <close>
    }
    exit(0);
  dc:	4501                	li	a0,0
  de:	00000097          	auipc	ra,0x0
  e2:	2f8080e7          	jalr	760(ra) # 3d6 <exit>

00000000000000e6 <main>:
}

int main()
{
  e6:	7179                	addi	sp,sp,-48
  e8:	f406                	sd	ra,40(sp)
  ea:	f022                	sd	s0,32(sp)
  ec:	ec26                	sd	s1,24(sp)
  ee:	1800                	addi	s0,sp,48
    int p[2];
    pipe(p);
  f0:	fd840513          	addi	a0,s0,-40
  f4:	00000097          	auipc	ra,0x0
  f8:	2f2080e7          	jalr	754(ra) # 3e6 <pipe>
    for (int i = 2; i <= SIZE; i++)
  fc:	4789                	li	a5,2
  fe:	fcf42a23          	sw	a5,-44(s0)
 102:	02200493          	li	s1,34
    {
        write(p[1], &i, 4); // 将2到SIZE(34)写入管道
 106:	4611                	li	a2,4
 108:	fd440593          	addi	a1,s0,-44
 10c:	fdc42503          	lw	a0,-36(s0)
 110:	00000097          	auipc	ra,0x0
 114:	2e6080e7          	jalr	742(ra) # 3f6 <write>
    for (int i = 2; i <= SIZE; i++)
 118:	fd442783          	lw	a5,-44(s0)
 11c:	2785                	addiw	a5,a5,1
 11e:	0007871b          	sext.w	a4,a5
 122:	fcf42a23          	sw	a5,-44(s0)
 126:	fee4d0e3          	bge	s1,a4,106 <main+0x20>
    }
    if(fork()==0)//创建子进程
 12a:	00000097          	auipc	ra,0x0
 12e:	2a4080e7          	jalr	676(ra) # 3ce <fork>
 132:	e519                	bnez	a0,140 <main+0x5a>
    {
        recur(p);
 134:	fd840513          	addi	a0,s0,-40
 138:	00000097          	auipc	ra,0x0
 13c:	ec8080e7          	jalr	-312(ra) # 0 <recur>
    }else{
        close(p[1]);
 140:	fdc42503          	lw	a0,-36(s0)
 144:	00000097          	auipc	ra,0x0
 148:	2ba080e7          	jalr	698(ra) # 3fe <close>
        wait(0);
 14c:	4501                	li	a0,0
 14e:	00000097          	auipc	ra,0x0
 152:	290080e7          	jalr	656(ra) # 3de <wait>
    }
exit(0);
 156:	4501                	li	a0,0
 158:	00000097          	auipc	ra,0x0
 15c:	27e080e7          	jalr	638(ra) # 3d6 <exit>

0000000000000160 <strcpy>:
#include "user/user.h"

//将字符串t复制到字符串s中，并返回s的起始地址
char*
strcpy(char *s, const char *t)
{
 160:	1141                	addi	sp,sp,-16
 162:	e422                	sd	s0,8(sp)
 164:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 166:	87aa                	mv	a5,a0
 168:	0585                	addi	a1,a1,1
 16a:	0785                	addi	a5,a5,1
 16c:	fff5c703          	lbu	a4,-1(a1)
 170:	fee78fa3          	sb	a4,-1(a5)
 174:	fb75                	bnez	a4,168 <strcpy+0x8>
    ;
  return os;
}
 176:	6422                	ld	s0,8(sp)
 178:	0141                	addi	sp,sp,16
 17a:	8082                	ret

000000000000017c <strcmp>:

//比较字符串p和q，返回差值
int
strcmp(const char *p, const char *q)
{
 17c:	1141                	addi	sp,sp,-16
 17e:	e422                	sd	s0,8(sp)
 180:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 182:	00054783          	lbu	a5,0(a0)
 186:	cb91                	beqz	a5,19a <strcmp+0x1e>
 188:	0005c703          	lbu	a4,0(a1)
 18c:	00f71763          	bne	a4,a5,19a <strcmp+0x1e>
    p++, q++;
 190:	0505                	addi	a0,a0,1
 192:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 194:	00054783          	lbu	a5,0(a0)
 198:	fbe5                	bnez	a5,188 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 19a:	0005c503          	lbu	a0,0(a1)
}
 19e:	40a7853b          	subw	a0,a5,a0
 1a2:	6422                	ld	s0,8(sp)
 1a4:	0141                	addi	sp,sp,16
 1a6:	8082                	ret

00000000000001a8 <strlen>:

//返回字符串s的长度n
uint
strlen(const char *s)
{
 1a8:	1141                	addi	sp,sp,-16
 1aa:	e422                	sd	s0,8(sp)
 1ac:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1ae:	00054783          	lbu	a5,0(a0)
 1b2:	cf91                	beqz	a5,1ce <strlen+0x26>
 1b4:	0505                	addi	a0,a0,1
 1b6:	87aa                	mv	a5,a0
 1b8:	4685                	li	a3,1
 1ba:	9e89                	subw	a3,a3,a0
 1bc:	00f6853b          	addw	a0,a3,a5
 1c0:	0785                	addi	a5,a5,1
 1c2:	fff7c703          	lbu	a4,-1(a5)
 1c6:	fb7d                	bnez	a4,1bc <strlen+0x14>
    ;
  return n;
}
 1c8:	6422                	ld	s0,8(sp)
 1ca:	0141                	addi	sp,sp,16
 1cc:	8082                	ret
  for(n = 0; s[n]; n++)
 1ce:	4501                	li	a0,0
 1d0:	bfe5                	j	1c8 <strlen+0x20>

00000000000001d2 <memset>:

//将前n个字节都设置为c
void*
memset(void *dst, int c, uint n)
{
 1d2:	1141                	addi	sp,sp,-16
 1d4:	e422                	sd	s0,8(sp)
 1d6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;//强制转换成char类型
  int i;
  for(i = 0; i < n; i++){
 1d8:	ce09                	beqz	a2,1f2 <memset+0x20>
 1da:	87aa                	mv	a5,a0
 1dc:	fff6071b          	addiw	a4,a2,-1
 1e0:	1702                	slli	a4,a4,0x20
 1e2:	9301                	srli	a4,a4,0x20
 1e4:	0705                	addi	a4,a4,1
 1e6:	972a                	add	a4,a4,a0
    cdst[i] = c;
 1e8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1ec:	0785                	addi	a5,a5,1
 1ee:	fee79de3          	bne	a5,a4,1e8 <memset+0x16>
  }
  return dst;
}
 1f2:	6422                	ld	s0,8(sp)
 1f4:	0141                	addi	sp,sp,16
 1f6:	8082                	ret

00000000000001f8 <strchr>:

//查找字符c，并返回指向该字符的指针
char*
strchr(const char *s, char c)
{
 1f8:	1141                	addi	sp,sp,-16
 1fa:	e422                	sd	s0,8(sp)
 1fc:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1fe:	00054783          	lbu	a5,0(a0)
 202:	cb99                	beqz	a5,218 <strchr+0x20>
    if(*s == c)
 204:	00f58763          	beq	a1,a5,212 <strchr+0x1a>
  for(; *s; s++)
 208:	0505                	addi	a0,a0,1
 20a:	00054783          	lbu	a5,0(a0)
 20e:	fbfd                	bnez	a5,204 <strchr+0xc>
      return (char*)s;
  return 0;
 210:	4501                	li	a0,0
}
 212:	6422                	ld	s0,8(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret
  return 0;
 218:	4501                	li	a0,0
 21a:	bfe5                	j	212 <strchr+0x1a>

000000000000021c <gets>:

//
char*
gets(char *buf, int max)
{
 21c:	711d                	addi	sp,sp,-96
 21e:	ec86                	sd	ra,88(sp)
 220:	e8a2                	sd	s0,80(sp)
 222:	e4a6                	sd	s1,72(sp)
 224:	e0ca                	sd	s2,64(sp)
 226:	fc4e                	sd	s3,56(sp)
 228:	f852                	sd	s4,48(sp)
 22a:	f456                	sd	s5,40(sp)
 22c:	f05a                	sd	s6,32(sp)
 22e:	ec5e                	sd	s7,24(sp)
 230:	1080                	addi	s0,sp,96
 232:	8baa                	mv	s7,a0
 234:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 236:	892a                	mv	s2,a0
 238:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 23a:	4aa9                	li	s5,10
 23c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 23e:	89a6                	mv	s3,s1
 240:	2485                	addiw	s1,s1,1
 242:	0344d863          	bge	s1,s4,272 <gets+0x56>
    cc = read(0, &c, 1);
 246:	4605                	li	a2,1
 248:	faf40593          	addi	a1,s0,-81
 24c:	4501                	li	a0,0
 24e:	00000097          	auipc	ra,0x0
 252:	1a0080e7          	jalr	416(ra) # 3ee <read>
    if(cc < 1)
 256:	00a05e63          	blez	a0,272 <gets+0x56>
    buf[i++] = c;
 25a:	faf44783          	lbu	a5,-81(s0)
 25e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 262:	01578763          	beq	a5,s5,270 <gets+0x54>
 266:	0905                	addi	s2,s2,1
 268:	fd679be3          	bne	a5,s6,23e <gets+0x22>
  for(i=0; i+1 < max; ){
 26c:	89a6                	mv	s3,s1
 26e:	a011                	j	272 <gets+0x56>
 270:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 272:	99de                	add	s3,s3,s7
 274:	00098023          	sb	zero,0(s3)
  return buf;
}
 278:	855e                	mv	a0,s7
 27a:	60e6                	ld	ra,88(sp)
 27c:	6446                	ld	s0,80(sp)
 27e:	64a6                	ld	s1,72(sp)
 280:	6906                	ld	s2,64(sp)
 282:	79e2                	ld	s3,56(sp)
 284:	7a42                	ld	s4,48(sp)
 286:	7aa2                	ld	s5,40(sp)
 288:	7b02                	ld	s6,32(sp)
 28a:	6be2                	ld	s7,24(sp)
 28c:	6125                	addi	sp,sp,96
 28e:	8082                	ret

0000000000000290 <stat>:

int
stat(const char *n, struct stat *st)
{
 290:	1101                	addi	sp,sp,-32
 292:	ec06                	sd	ra,24(sp)
 294:	e822                	sd	s0,16(sp)
 296:	e426                	sd	s1,8(sp)
 298:	e04a                	sd	s2,0(sp)
 29a:	1000                	addi	s0,sp,32
 29c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29e:	4581                	li	a1,0
 2a0:	00000097          	auipc	ra,0x0
 2a4:	176080e7          	jalr	374(ra) # 416 <open>
  if(fd < 0)
 2a8:	02054563          	bltz	a0,2d2 <stat+0x42>
 2ac:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2ae:	85ca                	mv	a1,s2
 2b0:	00000097          	auipc	ra,0x0
 2b4:	17e080e7          	jalr	382(ra) # 42e <fstat>
 2b8:	892a                	mv	s2,a0
  close(fd);
 2ba:	8526                	mv	a0,s1
 2bc:	00000097          	auipc	ra,0x0
 2c0:	142080e7          	jalr	322(ra) # 3fe <close>
  return r;
}
 2c4:	854a                	mv	a0,s2
 2c6:	60e2                	ld	ra,24(sp)
 2c8:	6442                	ld	s0,16(sp)
 2ca:	64a2                	ld	s1,8(sp)
 2cc:	6902                	ld	s2,0(sp)
 2ce:	6105                	addi	sp,sp,32
 2d0:	8082                	ret
    return -1;
 2d2:	597d                	li	s2,-1
 2d4:	bfc5                	j	2c4 <stat+0x34>

00000000000002d6 <atoi>:

int
atoi(const char *s)
{
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e422                	sd	s0,8(sp)
 2da:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2dc:	00054603          	lbu	a2,0(a0)
 2e0:	fd06079b          	addiw	a5,a2,-48
 2e4:	0ff7f793          	andi	a5,a5,255
 2e8:	4725                	li	a4,9
 2ea:	02f76963          	bltu	a4,a5,31c <atoi+0x46>
 2ee:	86aa                	mv	a3,a0
  n = 0;
 2f0:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2f2:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2f4:	0685                	addi	a3,a3,1
 2f6:	0025179b          	slliw	a5,a0,0x2
 2fa:	9fa9                	addw	a5,a5,a0
 2fc:	0017979b          	slliw	a5,a5,0x1
 300:	9fb1                	addw	a5,a5,a2
 302:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 306:	0006c603          	lbu	a2,0(a3)
 30a:	fd06071b          	addiw	a4,a2,-48
 30e:	0ff77713          	andi	a4,a4,255
 312:	fee5f1e3          	bgeu	a1,a4,2f4 <atoi+0x1e>
  return n;
}
 316:	6422                	ld	s0,8(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret
  n = 0;
 31c:	4501                	li	a0,0
 31e:	bfe5                	j	316 <atoi+0x40>

0000000000000320 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 320:	1141                	addi	sp,sp,-16
 322:	e422                	sd	s0,8(sp)
 324:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 326:	02b57663          	bgeu	a0,a1,352 <memmove+0x32>
    while(n-- > 0)
 32a:	02c05163          	blez	a2,34c <memmove+0x2c>
 32e:	fff6079b          	addiw	a5,a2,-1
 332:	1782                	slli	a5,a5,0x20
 334:	9381                	srli	a5,a5,0x20
 336:	0785                	addi	a5,a5,1
 338:	97aa                	add	a5,a5,a0
  dst = vdst;
 33a:	872a                	mv	a4,a0
      *dst++ = *src++;
 33c:	0585                	addi	a1,a1,1
 33e:	0705                	addi	a4,a4,1
 340:	fff5c683          	lbu	a3,-1(a1)
 344:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 348:	fee79ae3          	bne	a5,a4,33c <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 34c:	6422                	ld	s0,8(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret
    dst += n;
 352:	00c50733          	add	a4,a0,a2
    src += n;
 356:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 358:	fec05ae3          	blez	a2,34c <memmove+0x2c>
 35c:	fff6079b          	addiw	a5,a2,-1
 360:	1782                	slli	a5,a5,0x20
 362:	9381                	srli	a5,a5,0x20
 364:	fff7c793          	not	a5,a5
 368:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 36a:	15fd                	addi	a1,a1,-1
 36c:	177d                	addi	a4,a4,-1
 36e:	0005c683          	lbu	a3,0(a1)
 372:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 376:	fee79ae3          	bne	a5,a4,36a <memmove+0x4a>
 37a:	bfc9                	j	34c <memmove+0x2c>

000000000000037c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 37c:	1141                	addi	sp,sp,-16
 37e:	e422                	sd	s0,8(sp)
 380:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 382:	ca05                	beqz	a2,3b2 <memcmp+0x36>
 384:	fff6069b          	addiw	a3,a2,-1
 388:	1682                	slli	a3,a3,0x20
 38a:	9281                	srli	a3,a3,0x20
 38c:	0685                	addi	a3,a3,1
 38e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 390:	00054783          	lbu	a5,0(a0)
 394:	0005c703          	lbu	a4,0(a1)
 398:	00e79863          	bne	a5,a4,3a8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 39c:	0505                	addi	a0,a0,1
    p2++;
 39e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3a0:	fed518e3          	bne	a0,a3,390 <memcmp+0x14>
  }
  return 0;
 3a4:	4501                	li	a0,0
 3a6:	a019                	j	3ac <memcmp+0x30>
      return *p1 - *p2;
 3a8:	40e7853b          	subw	a0,a5,a4
}
 3ac:	6422                	ld	s0,8(sp)
 3ae:	0141                	addi	sp,sp,16
 3b0:	8082                	ret
  return 0;
 3b2:	4501                	li	a0,0
 3b4:	bfe5                	j	3ac <memcmp+0x30>

00000000000003b6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3b6:	1141                	addi	sp,sp,-16
 3b8:	e406                	sd	ra,8(sp)
 3ba:	e022                	sd	s0,0(sp)
 3bc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3be:	00000097          	auipc	ra,0x0
 3c2:	f62080e7          	jalr	-158(ra) # 320 <memmove>
}
 3c6:	60a2                	ld	ra,8(sp)
 3c8:	6402                	ld	s0,0(sp)
 3ca:	0141                	addi	sp,sp,16
 3cc:	8082                	ret

00000000000003ce <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ce:	4885                	li	a7,1
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3d6:	4889                	li	a7,2
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <wait>:
.global wait
wait:
 li a7, SYS_wait
 3de:	488d                	li	a7,3
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3e6:	4891                	li	a7,4
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <read>:
.global read
read:
 li a7, SYS_read
 3ee:	4895                	li	a7,5
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <write>:
.global write
write:
 li a7, SYS_write
 3f6:	48c1                	li	a7,16
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <close>:
.global close
close:
 li a7, SYS_close
 3fe:	48d5                	li	a7,21
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <kill>:
.global kill
kill:
 li a7, SYS_kill
 406:	4899                	li	a7,6
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <exec>:
.global exec
exec:
 li a7, SYS_exec
 40e:	489d                	li	a7,7
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <open>:
.global open
open:
 li a7, SYS_open
 416:	48bd                	li	a7,15
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 41e:	48c5                	li	a7,17
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 426:	48c9                	li	a7,18
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 42e:	48a1                	li	a7,8
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <link>:
.global link
link:
 li a7, SYS_link
 436:	48cd                	li	a7,19
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 43e:	48d1                	li	a7,20
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 446:	48a5                	li	a7,9
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <dup>:
.global dup
dup:
 li a7, SYS_dup
 44e:	48a9                	li	a7,10
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 456:	48ad                	li	a7,11
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 45e:	48b1                	li	a7,12
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 466:	48b5                	li	a7,13
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 46e:	48b9                	li	a7,14
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 476:	1101                	addi	sp,sp,-32
 478:	ec06                	sd	ra,24(sp)
 47a:	e822                	sd	s0,16(sp)
 47c:	1000                	addi	s0,sp,32
 47e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 482:	4605                	li	a2,1
 484:	fef40593          	addi	a1,s0,-17
 488:	00000097          	auipc	ra,0x0
 48c:	f6e080e7          	jalr	-146(ra) # 3f6 <write>
}
 490:	60e2                	ld	ra,24(sp)
 492:	6442                	ld	s0,16(sp)
 494:	6105                	addi	sp,sp,32
 496:	8082                	ret

0000000000000498 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 498:	7139                	addi	sp,sp,-64
 49a:	fc06                	sd	ra,56(sp)
 49c:	f822                	sd	s0,48(sp)
 49e:	f426                	sd	s1,40(sp)
 4a0:	f04a                	sd	s2,32(sp)
 4a2:	ec4e                	sd	s3,24(sp)
 4a4:	0080                	addi	s0,sp,64
 4a6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4a8:	c299                	beqz	a3,4ae <printint+0x16>
 4aa:	0805c863          	bltz	a1,53a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4ae:	2581                	sext.w	a1,a1
  neg = 0;
 4b0:	4881                	li	a7,0
 4b2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4b6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4b8:	2601                	sext.w	a2,a2
 4ba:	00000517          	auipc	a0,0x0
 4be:	44e50513          	addi	a0,a0,1102 # 908 <digits>
 4c2:	883a                	mv	a6,a4
 4c4:	2705                	addiw	a4,a4,1
 4c6:	02c5f7bb          	remuw	a5,a1,a2
 4ca:	1782                	slli	a5,a5,0x20
 4cc:	9381                	srli	a5,a5,0x20
 4ce:	97aa                	add	a5,a5,a0
 4d0:	0007c783          	lbu	a5,0(a5)
 4d4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4d8:	0005879b          	sext.w	a5,a1
 4dc:	02c5d5bb          	divuw	a1,a1,a2
 4e0:	0685                	addi	a3,a3,1
 4e2:	fec7f0e3          	bgeu	a5,a2,4c2 <printint+0x2a>
  if(neg)
 4e6:	00088b63          	beqz	a7,4fc <printint+0x64>
    buf[i++] = '-';
 4ea:	fd040793          	addi	a5,s0,-48
 4ee:	973e                	add	a4,a4,a5
 4f0:	02d00793          	li	a5,45
 4f4:	fef70823          	sb	a5,-16(a4)
 4f8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4fc:	02e05863          	blez	a4,52c <printint+0x94>
 500:	fc040793          	addi	a5,s0,-64
 504:	00e78933          	add	s2,a5,a4
 508:	fff78993          	addi	s3,a5,-1
 50c:	99ba                	add	s3,s3,a4
 50e:	377d                	addiw	a4,a4,-1
 510:	1702                	slli	a4,a4,0x20
 512:	9301                	srli	a4,a4,0x20
 514:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 518:	fff94583          	lbu	a1,-1(s2)
 51c:	8526                	mv	a0,s1
 51e:	00000097          	auipc	ra,0x0
 522:	f58080e7          	jalr	-168(ra) # 476 <putc>
  while(--i >= 0)
 526:	197d                	addi	s2,s2,-1
 528:	ff3918e3          	bne	s2,s3,518 <printint+0x80>
}
 52c:	70e2                	ld	ra,56(sp)
 52e:	7442                	ld	s0,48(sp)
 530:	74a2                	ld	s1,40(sp)
 532:	7902                	ld	s2,32(sp)
 534:	69e2                	ld	s3,24(sp)
 536:	6121                	addi	sp,sp,64
 538:	8082                	ret
    x = -xx;
 53a:	40b005bb          	negw	a1,a1
    neg = 1;
 53e:	4885                	li	a7,1
    x = -xx;
 540:	bf8d                	j	4b2 <printint+0x1a>

0000000000000542 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 542:	7119                	addi	sp,sp,-128
 544:	fc86                	sd	ra,120(sp)
 546:	f8a2                	sd	s0,112(sp)
 548:	f4a6                	sd	s1,104(sp)
 54a:	f0ca                	sd	s2,96(sp)
 54c:	ecce                	sd	s3,88(sp)
 54e:	e8d2                	sd	s4,80(sp)
 550:	e4d6                	sd	s5,72(sp)
 552:	e0da                	sd	s6,64(sp)
 554:	fc5e                	sd	s7,56(sp)
 556:	f862                	sd	s8,48(sp)
 558:	f466                	sd	s9,40(sp)
 55a:	f06a                	sd	s10,32(sp)
 55c:	ec6e                	sd	s11,24(sp)
 55e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 560:	0005c903          	lbu	s2,0(a1)
 564:	18090f63          	beqz	s2,702 <vprintf+0x1c0>
 568:	8aaa                	mv	s5,a0
 56a:	8b32                	mv	s6,a2
 56c:	00158493          	addi	s1,a1,1
  state = 0;
 570:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 572:	02500a13          	li	s4,37
      if(c == 'd'){
 576:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 57a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 57e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 582:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 586:	00000b97          	auipc	s7,0x0
 58a:	382b8b93          	addi	s7,s7,898 # 908 <digits>
 58e:	a839                	j	5ac <vprintf+0x6a>
        putc(fd, c);
 590:	85ca                	mv	a1,s2
 592:	8556                	mv	a0,s5
 594:	00000097          	auipc	ra,0x0
 598:	ee2080e7          	jalr	-286(ra) # 476 <putc>
 59c:	a019                	j	5a2 <vprintf+0x60>
    } else if(state == '%'){
 59e:	01498f63          	beq	s3,s4,5bc <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5a2:	0485                	addi	s1,s1,1
 5a4:	fff4c903          	lbu	s2,-1(s1)
 5a8:	14090d63          	beqz	s2,702 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5ac:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5b0:	fe0997e3          	bnez	s3,59e <vprintf+0x5c>
      if(c == '%'){
 5b4:	fd479ee3          	bne	a5,s4,590 <vprintf+0x4e>
        state = '%';
 5b8:	89be                	mv	s3,a5
 5ba:	b7e5                	j	5a2 <vprintf+0x60>
      if(c == 'd'){
 5bc:	05878063          	beq	a5,s8,5fc <vprintf+0xba>
      } else if(c == 'l') {
 5c0:	05978c63          	beq	a5,s9,618 <vprintf+0xd6>
      } else if(c == 'x') {
 5c4:	07a78863          	beq	a5,s10,634 <vprintf+0xf2>
      } else if(c == 'p') {
 5c8:	09b78463          	beq	a5,s11,650 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5cc:	07300713          	li	a4,115
 5d0:	0ce78663          	beq	a5,a4,69c <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5d4:	06300713          	li	a4,99
 5d8:	0ee78e63          	beq	a5,a4,6d4 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5dc:	11478863          	beq	a5,s4,6ec <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5e0:	85d2                	mv	a1,s4
 5e2:	8556                	mv	a0,s5
 5e4:	00000097          	auipc	ra,0x0
 5e8:	e92080e7          	jalr	-366(ra) # 476 <putc>
        putc(fd, c);
 5ec:	85ca                	mv	a1,s2
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	e86080e7          	jalr	-378(ra) # 476 <putc>
      }
      state = 0;
 5f8:	4981                	li	s3,0
 5fa:	b765                	j	5a2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 5fc:	008b0913          	addi	s2,s6,8
 600:	4685                	li	a3,1
 602:	4629                	li	a2,10
 604:	000b2583          	lw	a1,0(s6)
 608:	8556                	mv	a0,s5
 60a:	00000097          	auipc	ra,0x0
 60e:	e8e080e7          	jalr	-370(ra) # 498 <printint>
 612:	8b4a                	mv	s6,s2
      state = 0;
 614:	4981                	li	s3,0
 616:	b771                	j	5a2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 618:	008b0913          	addi	s2,s6,8
 61c:	4681                	li	a3,0
 61e:	4629                	li	a2,10
 620:	000b2583          	lw	a1,0(s6)
 624:	8556                	mv	a0,s5
 626:	00000097          	auipc	ra,0x0
 62a:	e72080e7          	jalr	-398(ra) # 498 <printint>
 62e:	8b4a                	mv	s6,s2
      state = 0;
 630:	4981                	li	s3,0
 632:	bf85                	j	5a2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 634:	008b0913          	addi	s2,s6,8
 638:	4681                	li	a3,0
 63a:	4641                	li	a2,16
 63c:	000b2583          	lw	a1,0(s6)
 640:	8556                	mv	a0,s5
 642:	00000097          	auipc	ra,0x0
 646:	e56080e7          	jalr	-426(ra) # 498 <printint>
 64a:	8b4a                	mv	s6,s2
      state = 0;
 64c:	4981                	li	s3,0
 64e:	bf91                	j	5a2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 650:	008b0793          	addi	a5,s6,8
 654:	f8f43423          	sd	a5,-120(s0)
 658:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 65c:	03000593          	li	a1,48
 660:	8556                	mv	a0,s5
 662:	00000097          	auipc	ra,0x0
 666:	e14080e7          	jalr	-492(ra) # 476 <putc>
  putc(fd, 'x');
 66a:	85ea                	mv	a1,s10
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	e08080e7          	jalr	-504(ra) # 476 <putc>
 676:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 678:	03c9d793          	srli	a5,s3,0x3c
 67c:	97de                	add	a5,a5,s7
 67e:	0007c583          	lbu	a1,0(a5)
 682:	8556                	mv	a0,s5
 684:	00000097          	auipc	ra,0x0
 688:	df2080e7          	jalr	-526(ra) # 476 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 68c:	0992                	slli	s3,s3,0x4
 68e:	397d                	addiw	s2,s2,-1
 690:	fe0914e3          	bnez	s2,678 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 694:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 698:	4981                	li	s3,0
 69a:	b721                	j	5a2 <vprintf+0x60>
        s = va_arg(ap, char*);
 69c:	008b0993          	addi	s3,s6,8
 6a0:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6a4:	02090163          	beqz	s2,6c6 <vprintf+0x184>
        while(*s != 0){
 6a8:	00094583          	lbu	a1,0(s2)
 6ac:	c9a1                	beqz	a1,6fc <vprintf+0x1ba>
          putc(fd, *s);
 6ae:	8556                	mv	a0,s5
 6b0:	00000097          	auipc	ra,0x0
 6b4:	dc6080e7          	jalr	-570(ra) # 476 <putc>
          s++;
 6b8:	0905                	addi	s2,s2,1
        while(*s != 0){
 6ba:	00094583          	lbu	a1,0(s2)
 6be:	f9e5                	bnez	a1,6ae <vprintf+0x16c>
        s = va_arg(ap, char*);
 6c0:	8b4e                	mv	s6,s3
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	bdf9                	j	5a2 <vprintf+0x60>
          s = "(null)";
 6c6:	00000917          	auipc	s2,0x0
 6ca:	23a90913          	addi	s2,s2,570 # 900 <malloc+0xf4>
        while(*s != 0){
 6ce:	02800593          	li	a1,40
 6d2:	bff1                	j	6ae <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6d4:	008b0913          	addi	s2,s6,8
 6d8:	000b4583          	lbu	a1,0(s6)
 6dc:	8556                	mv	a0,s5
 6de:	00000097          	auipc	ra,0x0
 6e2:	d98080e7          	jalr	-616(ra) # 476 <putc>
 6e6:	8b4a                	mv	s6,s2
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	bd65                	j	5a2 <vprintf+0x60>
        putc(fd, c);
 6ec:	85d2                	mv	a1,s4
 6ee:	8556                	mv	a0,s5
 6f0:	00000097          	auipc	ra,0x0
 6f4:	d86080e7          	jalr	-634(ra) # 476 <putc>
      state = 0;
 6f8:	4981                	li	s3,0
 6fa:	b565                	j	5a2 <vprintf+0x60>
        s = va_arg(ap, char*);
 6fc:	8b4e                	mv	s6,s3
      state = 0;
 6fe:	4981                	li	s3,0
 700:	b54d                	j	5a2 <vprintf+0x60>
    }
  }
}
 702:	70e6                	ld	ra,120(sp)
 704:	7446                	ld	s0,112(sp)
 706:	74a6                	ld	s1,104(sp)
 708:	7906                	ld	s2,96(sp)
 70a:	69e6                	ld	s3,88(sp)
 70c:	6a46                	ld	s4,80(sp)
 70e:	6aa6                	ld	s5,72(sp)
 710:	6b06                	ld	s6,64(sp)
 712:	7be2                	ld	s7,56(sp)
 714:	7c42                	ld	s8,48(sp)
 716:	7ca2                	ld	s9,40(sp)
 718:	7d02                	ld	s10,32(sp)
 71a:	6de2                	ld	s11,24(sp)
 71c:	6109                	addi	sp,sp,128
 71e:	8082                	ret

0000000000000720 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 720:	715d                	addi	sp,sp,-80
 722:	ec06                	sd	ra,24(sp)
 724:	e822                	sd	s0,16(sp)
 726:	1000                	addi	s0,sp,32
 728:	e010                	sd	a2,0(s0)
 72a:	e414                	sd	a3,8(s0)
 72c:	e818                	sd	a4,16(s0)
 72e:	ec1c                	sd	a5,24(s0)
 730:	03043023          	sd	a6,32(s0)
 734:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 738:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 73c:	8622                	mv	a2,s0
 73e:	00000097          	auipc	ra,0x0
 742:	e04080e7          	jalr	-508(ra) # 542 <vprintf>
}
 746:	60e2                	ld	ra,24(sp)
 748:	6442                	ld	s0,16(sp)
 74a:	6161                	addi	sp,sp,80
 74c:	8082                	ret

000000000000074e <printf>:

void
printf(const char *fmt, ...)
{
 74e:	711d                	addi	sp,sp,-96
 750:	ec06                	sd	ra,24(sp)
 752:	e822                	sd	s0,16(sp)
 754:	1000                	addi	s0,sp,32
 756:	e40c                	sd	a1,8(s0)
 758:	e810                	sd	a2,16(s0)
 75a:	ec14                	sd	a3,24(s0)
 75c:	f018                	sd	a4,32(s0)
 75e:	f41c                	sd	a5,40(s0)
 760:	03043823          	sd	a6,48(s0)
 764:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 768:	00840613          	addi	a2,s0,8
 76c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 770:	85aa                	mv	a1,a0
 772:	4505                	li	a0,1
 774:	00000097          	auipc	ra,0x0
 778:	dce080e7          	jalr	-562(ra) # 542 <vprintf>
}
 77c:	60e2                	ld	ra,24(sp)
 77e:	6442                	ld	s0,16(sp)
 780:	6125                	addi	sp,sp,96
 782:	8082                	ret

0000000000000784 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 784:	1141                	addi	sp,sp,-16
 786:	e422                	sd	s0,8(sp)
 788:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 78a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78e:	00000797          	auipc	a5,0x0
 792:	1927b783          	ld	a5,402(a5) # 920 <freep>
 796:	a805                	j	7c6 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 798:	4618                	lw	a4,8(a2)
 79a:	9db9                	addw	a1,a1,a4
 79c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a0:	6398                	ld	a4,0(a5)
 7a2:	6318                	ld	a4,0(a4)
 7a4:	fee53823          	sd	a4,-16(a0)
 7a8:	a091                	j	7ec <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7aa:	ff852703          	lw	a4,-8(a0)
 7ae:	9e39                	addw	a2,a2,a4
 7b0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7b2:	ff053703          	ld	a4,-16(a0)
 7b6:	e398                	sd	a4,0(a5)
 7b8:	a099                	j	7fe <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ba:	6398                	ld	a4,0(a5)
 7bc:	00e7e463          	bltu	a5,a4,7c4 <free+0x40>
 7c0:	00e6ea63          	bltu	a3,a4,7d4 <free+0x50>
{
 7c4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c6:	fed7fae3          	bgeu	a5,a3,7ba <free+0x36>
 7ca:	6398                	ld	a4,0(a5)
 7cc:	00e6e463          	bltu	a3,a4,7d4 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d0:	fee7eae3          	bltu	a5,a4,7c4 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7d4:	ff852583          	lw	a1,-8(a0)
 7d8:	6390                	ld	a2,0(a5)
 7da:	02059713          	slli	a4,a1,0x20
 7de:	9301                	srli	a4,a4,0x20
 7e0:	0712                	slli	a4,a4,0x4
 7e2:	9736                	add	a4,a4,a3
 7e4:	fae60ae3          	beq	a2,a4,798 <free+0x14>
    bp->s.ptr = p->s.ptr;
 7e8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7ec:	4790                	lw	a2,8(a5)
 7ee:	02061713          	slli	a4,a2,0x20
 7f2:	9301                	srli	a4,a4,0x20
 7f4:	0712                	slli	a4,a4,0x4
 7f6:	973e                	add	a4,a4,a5
 7f8:	fae689e3          	beq	a3,a4,7aa <free+0x26>
  } else
    p->s.ptr = bp;
 7fc:	e394                	sd	a3,0(a5)
  freep = p;
 7fe:	00000717          	auipc	a4,0x0
 802:	12f73123          	sd	a5,290(a4) # 920 <freep>
}
 806:	6422                	ld	s0,8(sp)
 808:	0141                	addi	sp,sp,16
 80a:	8082                	ret

000000000000080c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 80c:	7139                	addi	sp,sp,-64
 80e:	fc06                	sd	ra,56(sp)
 810:	f822                	sd	s0,48(sp)
 812:	f426                	sd	s1,40(sp)
 814:	f04a                	sd	s2,32(sp)
 816:	ec4e                	sd	s3,24(sp)
 818:	e852                	sd	s4,16(sp)
 81a:	e456                	sd	s5,8(sp)
 81c:	e05a                	sd	s6,0(sp)
 81e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 820:	02051493          	slli	s1,a0,0x20
 824:	9081                	srli	s1,s1,0x20
 826:	04bd                	addi	s1,s1,15
 828:	8091                	srli	s1,s1,0x4
 82a:	0014899b          	addiw	s3,s1,1
 82e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 830:	00000517          	auipc	a0,0x0
 834:	0f053503          	ld	a0,240(a0) # 920 <freep>
 838:	c515                	beqz	a0,864 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 83c:	4798                	lw	a4,8(a5)
 83e:	02977f63          	bgeu	a4,s1,87c <malloc+0x70>
 842:	8a4e                	mv	s4,s3
 844:	0009871b          	sext.w	a4,s3
 848:	6685                	lui	a3,0x1
 84a:	00d77363          	bgeu	a4,a3,850 <malloc+0x44>
 84e:	6a05                	lui	s4,0x1
 850:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 854:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 858:	00000917          	auipc	s2,0x0
 85c:	0c890913          	addi	s2,s2,200 # 920 <freep>
  if(p == (char*)-1)
 860:	5afd                	li	s5,-1
 862:	a88d                	j	8d4 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 864:	00000797          	auipc	a5,0x0
 868:	0c478793          	addi	a5,a5,196 # 928 <base>
 86c:	00000717          	auipc	a4,0x0
 870:	0af73a23          	sd	a5,180(a4) # 920 <freep>
 874:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 876:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 87a:	b7e1                	j	842 <malloc+0x36>
      if(p->s.size == nunits)
 87c:	02e48b63          	beq	s1,a4,8b2 <malloc+0xa6>
        p->s.size -= nunits;
 880:	4137073b          	subw	a4,a4,s3
 884:	c798                	sw	a4,8(a5)
        p += p->s.size;
 886:	1702                	slli	a4,a4,0x20
 888:	9301                	srli	a4,a4,0x20
 88a:	0712                	slli	a4,a4,0x4
 88c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 88e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 892:	00000717          	auipc	a4,0x0
 896:	08a73723          	sd	a0,142(a4) # 920 <freep>
      return (void*)(p + 1);
 89a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 89e:	70e2                	ld	ra,56(sp)
 8a0:	7442                	ld	s0,48(sp)
 8a2:	74a2                	ld	s1,40(sp)
 8a4:	7902                	ld	s2,32(sp)
 8a6:	69e2                	ld	s3,24(sp)
 8a8:	6a42                	ld	s4,16(sp)
 8aa:	6aa2                	ld	s5,8(sp)
 8ac:	6b02                	ld	s6,0(sp)
 8ae:	6121                	addi	sp,sp,64
 8b0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8b2:	6398                	ld	a4,0(a5)
 8b4:	e118                	sd	a4,0(a0)
 8b6:	bff1                	j	892 <malloc+0x86>
  hp->s.size = nu;
 8b8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8bc:	0541                	addi	a0,a0,16
 8be:	00000097          	auipc	ra,0x0
 8c2:	ec6080e7          	jalr	-314(ra) # 784 <free>
  return freep;
 8c6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8ca:	d971                	beqz	a0,89e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8cc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ce:	4798                	lw	a4,8(a5)
 8d0:	fa9776e3          	bgeu	a4,s1,87c <malloc+0x70>
    if(p == freep)
 8d4:	00093703          	ld	a4,0(s2)
 8d8:	853e                	mv	a0,a5
 8da:	fef719e3          	bne	a4,a5,8cc <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 8de:	8552                	mv	a0,s4
 8e0:	00000097          	auipc	ra,0x0
 8e4:	b7e080e7          	jalr	-1154(ra) # 45e <sbrk>
  if(p == (char*)-1)
 8e8:	fd5518e3          	bne	a0,s5,8b8 <malloc+0xac>
        return 0;
 8ec:	4501                	li	a0,0
 8ee:	bf45                	j	89e <malloc+0x92>
