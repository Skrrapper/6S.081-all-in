
user/_xargs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/param.h"

int main(int argc, char *argv[]) {
   0:	cd010113          	addi	sp,sp,-816
   4:	32113423          	sd	ra,808(sp)
   8:	32813023          	sd	s0,800(sp)
   c:	30913c23          	sd	s1,792(sp)
  10:	31213823          	sd	s2,784(sp)
  14:	31313423          	sd	s3,776(sp)
  18:	31413023          	sd	s4,768(sp)
  1c:	1e00                	addi	s0,sp,816
  1e:	84aa                	mv	s1,a0
  20:	892e                	mv	s2,a1
    //从标准输入读取数据
    char stdIn[512];
    int size = read(0, stdIn, sizeof stdIn);
  22:	20000613          	li	a2,512
  26:	dd040593          	addi	a1,s0,-560
  2a:	4501                	li	a0,0
  2c:	00000097          	auipc	ra,0x0
  30:	3ac080e7          	jalr	940(ra) # 3d8 <read>
    //将数据分行存储
    int i = 0, j = 0;
    int line = 0;
    for (int k = 0; k < size; ++k) {
  34:	10a05463          	blez	a0,13c <main+0x13c>
  38:	dd040793          	addi	a5,s0,-560
  3c:	357d                	addiw	a0,a0,-1
  3e:	1502                	slli	a0,a0,0x20
  40:	9101                	srli	a0,a0,0x20
  42:	dd140713          	addi	a4,s0,-559
  46:	953a                	add	a0,a0,a4
  48:	873e                	mv	a4,a5
    int line = 0;
  4a:	4681                	li	a3,0
        if (stdIn[k] == '\n') { // 根据换行符的个数统计数据的行数
  4c:	45a9                	li	a1,10
  4e:	a021                	j	56 <main+0x56>
    for (int k = 0; k < size; ++k) {
  50:	0705                	addi	a4,a4,1
  52:	0ca70b63          	beq	a4,a0,128 <main+0x128>
        if (stdIn[k] == '\n') { // 根据换行符的个数统计数据的行数
  56:	00074603          	lbu	a2,0(a4)
  5a:	feb61be3          	bne	a2,a1,50 <main+0x50>
            ++line;
  5e:	2685                	addiw	a3,a3,1
  60:	bfc5                	j	50 <main+0x50>
    }
    char output[line][64]; // 根据提示中的MAXARG，命令参数长度最长为32个字节
    for (int k = 0; k < size; ++k) {
        output[i][j++] = stdIn[k];
        if (stdIn[k] == '\n') {
            output[i][j - 1] = 0; // 用0覆盖掉换行符。C语言没有字符串类型，char类型的数组中，'0'表示字符串的结束
  62:	00681713          	slli	a4,a6,0x6
  66:	9746                	add	a4,a4,a7
  68:	963a                	add	a2,a2,a4
  6a:	00060023          	sb	zero,0(a2)
            ++i; // 继续保存下一行数据
  6e:	2805                	addiw	a6,a6,1
            j = 0;
  70:	8672                	mv	a2,t3
    for (int k = 0; k < size; ++k) {
  72:	0785                	addi	a5,a5,1
  74:	00a78e63          	beq	a5,a0,90 <main+0x90>
        output[i][j++] = stdIn[k];
  78:	0007c583          	lbu	a1,0(a5)
        if (stdIn[k] == '\n') {
  7c:	fe6583e3          	beq	a1,t1,62 <main+0x62>
        output[i][j++] = stdIn[k];
  80:	00681713          	slli	a4,a6,0x6
  84:	9746                	add	a4,a4,a7
  86:	9732                	add	a4,a4,a2
  88:	00b70023          	sb	a1,0(a4)
  8c:	2605                	addiw	a2,a2,1
  8e:	b7d5                	j	72 <main+0x72>
        }
    }
    //将数据分行拼接到argv[2]后，并运行
    char *arguments[MAXARG];
    for (j = 0; j < argc - 1; ++j) {
  90:	4785                	li	a5,1
  92:	0697dc63          	bge	a5,s1,10a <main+0x10a>
  96:	00890713          	addi	a4,s2,8
  9a:	cd040793          	addi	a5,s0,-816
  9e:	0004899b          	sext.w	s3,s1
  a2:	ffe4859b          	addiw	a1,s1,-2
  a6:	1582                	slli	a1,a1,0x20
  a8:	9181                	srli	a1,a1,0x20
  aa:	058e                	slli	a1,a1,0x3
  ac:	cd840613          	addi	a2,s0,-808
  b0:	95b2                	add	a1,a1,a2
        arguments[j] = argv[1 + j]; // 从argv[1]开始，保存原本的命令+命令参数
  b2:	6310                	ld	a2,0(a4)
  b4:	e390                	sd	a2,0(a5)
    for (j = 0; j < argc - 1; ++j) {
  b6:	0721                	addi	a4,a4,8
  b8:	07a1                	addi	a5,a5,8
  ba:	feb79ce3          	bne	a5,a1,b2 <main+0xb2>
  be:	39fd                	addiw	s3,s3,-1
    }
    i = 0;
    while (i < line) {
  c0:	04d05063          	blez	a3,100 <main+0x100>
  c4:	84c6                	mv	s1,a7
  c6:	fff68a1b          	addiw	s4,a3,-1
  ca:	1a02                	slli	s4,s4,0x20
  cc:	020a5a13          	srli	s4,s4,0x20
  d0:	0a1a                	slli	s4,s4,0x6
  d2:	04088893          	addi	a7,a7,64
  d6:	9a46                	add	s4,s4,a7
        arguments[j] = output[i++]; // 将每一行数据都分别拼接在原命令参数后
  d8:	098e                	slli	s3,s3,0x3
  da:	fd040793          	addi	a5,s0,-48
  de:	99be                	add	s3,s3,a5
  e0:	d099b023          	sd	s1,-768(s3)
        if (fork() == 0) {
  e4:	00000097          	auipc	ra,0x0
  e8:	2d4080e7          	jalr	724(ra) # 3b8 <fork>
  ec:	c10d                	beqz	a0,10e <main+0x10e>
            exec(argv[1], arguments);
            exit(0);
        }
        wait(0);
  ee:	4501                	li	a0,0
  f0:	00000097          	auipc	ra,0x0
  f4:	2d8080e7          	jalr	728(ra) # 3c8 <wait>
    while (i < line) {
  f8:	04048493          	addi	s1,s1,64
  fc:	fe9a12e3          	bne	s4,s1,e0 <main+0xe0>
    }
    exit(0);
 100:	4501                	li	a0,0
 102:	00000097          	auipc	ra,0x0
 106:	2be080e7          	jalr	702(ra) # 3c0 <exit>
    for (j = 0; j < argc - 1; ++j) {
 10a:	4981                	li	s3,0
 10c:	bf55                	j	c0 <main+0xc0>
            exec(argv[1], arguments);
 10e:	cd040593          	addi	a1,s0,-816
 112:	00893503          	ld	a0,8(s2)
 116:	00000097          	auipc	ra,0x0
 11a:	2e2080e7          	jalr	738(ra) # 3f8 <exec>
            exit(0);
 11e:	4501                	li	a0,0
 120:	00000097          	auipc	ra,0x0
 124:	2a0080e7          	jalr	672(ra) # 3c0 <exit>
    char output[line][64]; // 根据提示中的MAXARG，命令参数长度最长为32个字节
 128:	00669713          	slli	a4,a3,0x6
 12c:	40e10133          	sub	sp,sp,a4
 130:	888a                	mv	a7,sp
 132:	4801                	li	a6,0
 134:	4601                	li	a2,0
        if (stdIn[k] == '\n') {
 136:	4329                	li	t1,10
            j = 0;
 138:	4e01                	li	t3,0
 13a:	bf3d                	j	78 <main+0x78>
    for (j = 0; j < argc - 1; ++j) {
 13c:	4785                	li	a5,1
    int line = 0;
 13e:	4681                	li	a3,0
    char output[line][64]; // 根据提示中的MAXARG，命令参数长度最长为32个字节
 140:	fd040893          	addi	a7,s0,-48
    for (j = 0; j < argc - 1; ++j) {
 144:	f497c9e3          	blt	a5,s1,96 <main+0x96>
 148:	bf65                	j	100 <main+0x100>

000000000000014a <strcpy>:
#include "user/user.h"

//将字符串t复制到字符串s中，并返回s的起始地址
char*
strcpy(char *s, const char *t)
{
 14a:	1141                	addi	sp,sp,-16
 14c:	e422                	sd	s0,8(sp)
 14e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 150:	87aa                	mv	a5,a0
 152:	0585                	addi	a1,a1,1
 154:	0785                	addi	a5,a5,1
 156:	fff5c703          	lbu	a4,-1(a1)
 15a:	fee78fa3          	sb	a4,-1(a5)
 15e:	fb75                	bnez	a4,152 <strcpy+0x8>
    ;
  return os;
}
 160:	6422                	ld	s0,8(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret

0000000000000166 <strcmp>:

//比较字符串p和q，返回差值
int
strcmp(const char *p, const char *q)
{
 166:	1141                	addi	sp,sp,-16
 168:	e422                	sd	s0,8(sp)
 16a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 16c:	00054783          	lbu	a5,0(a0)
 170:	cb91                	beqz	a5,184 <strcmp+0x1e>
 172:	0005c703          	lbu	a4,0(a1)
 176:	00f71763          	bne	a4,a5,184 <strcmp+0x1e>
    p++, q++;
 17a:	0505                	addi	a0,a0,1
 17c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 17e:	00054783          	lbu	a5,0(a0)
 182:	fbe5                	bnez	a5,172 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 184:	0005c503          	lbu	a0,0(a1)
}
 188:	40a7853b          	subw	a0,a5,a0
 18c:	6422                	ld	s0,8(sp)
 18e:	0141                	addi	sp,sp,16
 190:	8082                	ret

0000000000000192 <strlen>:

//返回字符串s的长度n
uint
strlen(const char *s)
{
 192:	1141                	addi	sp,sp,-16
 194:	e422                	sd	s0,8(sp)
 196:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 198:	00054783          	lbu	a5,0(a0)
 19c:	cf91                	beqz	a5,1b8 <strlen+0x26>
 19e:	0505                	addi	a0,a0,1
 1a0:	87aa                	mv	a5,a0
 1a2:	4685                	li	a3,1
 1a4:	9e89                	subw	a3,a3,a0
 1a6:	00f6853b          	addw	a0,a3,a5
 1aa:	0785                	addi	a5,a5,1
 1ac:	fff7c703          	lbu	a4,-1(a5)
 1b0:	fb7d                	bnez	a4,1a6 <strlen+0x14>
    ;
  return n;
}
 1b2:	6422                	ld	s0,8(sp)
 1b4:	0141                	addi	sp,sp,16
 1b6:	8082                	ret
  for(n = 0; s[n]; n++)
 1b8:	4501                	li	a0,0
 1ba:	bfe5                	j	1b2 <strlen+0x20>

00000000000001bc <memset>:

//将前n个字节都设置为c
void*
memset(void *dst, int c, uint n)
{
 1bc:	1141                	addi	sp,sp,-16
 1be:	e422                	sd	s0,8(sp)
 1c0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;//强制转换成char类型
  int i;
  for(i = 0; i < n; i++){
 1c2:	ce09                	beqz	a2,1dc <memset+0x20>
 1c4:	87aa                	mv	a5,a0
 1c6:	fff6071b          	addiw	a4,a2,-1
 1ca:	1702                	slli	a4,a4,0x20
 1cc:	9301                	srli	a4,a4,0x20
 1ce:	0705                	addi	a4,a4,1
 1d0:	972a                	add	a4,a4,a0
    cdst[i] = c;
 1d2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1d6:	0785                	addi	a5,a5,1
 1d8:	fee79de3          	bne	a5,a4,1d2 <memset+0x16>
  }
  return dst;
}
 1dc:	6422                	ld	s0,8(sp)
 1de:	0141                	addi	sp,sp,16
 1e0:	8082                	ret

00000000000001e2 <strchr>:

//查找字符c，并返回指向该字符的指针
char*
strchr(const char *s, char c)
{
 1e2:	1141                	addi	sp,sp,-16
 1e4:	e422                	sd	s0,8(sp)
 1e6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1e8:	00054783          	lbu	a5,0(a0)
 1ec:	cb99                	beqz	a5,202 <strchr+0x20>
    if(*s == c)
 1ee:	00f58763          	beq	a1,a5,1fc <strchr+0x1a>
  for(; *s; s++)
 1f2:	0505                	addi	a0,a0,1
 1f4:	00054783          	lbu	a5,0(a0)
 1f8:	fbfd                	bnez	a5,1ee <strchr+0xc>
      return (char*)s;
  return 0;
 1fa:	4501                	li	a0,0
}
 1fc:	6422                	ld	s0,8(sp)
 1fe:	0141                	addi	sp,sp,16
 200:	8082                	ret
  return 0;
 202:	4501                	li	a0,0
 204:	bfe5                	j	1fc <strchr+0x1a>

0000000000000206 <gets>:

//
char*
gets(char *buf, int max)
{
 206:	711d                	addi	sp,sp,-96
 208:	ec86                	sd	ra,88(sp)
 20a:	e8a2                	sd	s0,80(sp)
 20c:	e4a6                	sd	s1,72(sp)
 20e:	e0ca                	sd	s2,64(sp)
 210:	fc4e                	sd	s3,56(sp)
 212:	f852                	sd	s4,48(sp)
 214:	f456                	sd	s5,40(sp)
 216:	f05a                	sd	s6,32(sp)
 218:	ec5e                	sd	s7,24(sp)
 21a:	1080                	addi	s0,sp,96
 21c:	8baa                	mv	s7,a0
 21e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 220:	892a                	mv	s2,a0
 222:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 224:	4aa9                	li	s5,10
 226:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 228:	89a6                	mv	s3,s1
 22a:	2485                	addiw	s1,s1,1
 22c:	0344d863          	bge	s1,s4,25c <gets+0x56>
    cc = read(0, &c, 1);
 230:	4605                	li	a2,1
 232:	faf40593          	addi	a1,s0,-81
 236:	4501                	li	a0,0
 238:	00000097          	auipc	ra,0x0
 23c:	1a0080e7          	jalr	416(ra) # 3d8 <read>
    if(cc < 1)
 240:	00a05e63          	blez	a0,25c <gets+0x56>
    buf[i++] = c;
 244:	faf44783          	lbu	a5,-81(s0)
 248:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 24c:	01578763          	beq	a5,s5,25a <gets+0x54>
 250:	0905                	addi	s2,s2,1
 252:	fd679be3          	bne	a5,s6,228 <gets+0x22>
  for(i=0; i+1 < max; ){
 256:	89a6                	mv	s3,s1
 258:	a011                	j	25c <gets+0x56>
 25a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 25c:	99de                	add	s3,s3,s7
 25e:	00098023          	sb	zero,0(s3)
  return buf;
}
 262:	855e                	mv	a0,s7
 264:	60e6                	ld	ra,88(sp)
 266:	6446                	ld	s0,80(sp)
 268:	64a6                	ld	s1,72(sp)
 26a:	6906                	ld	s2,64(sp)
 26c:	79e2                	ld	s3,56(sp)
 26e:	7a42                	ld	s4,48(sp)
 270:	7aa2                	ld	s5,40(sp)
 272:	7b02                	ld	s6,32(sp)
 274:	6be2                	ld	s7,24(sp)
 276:	6125                	addi	sp,sp,96
 278:	8082                	ret

000000000000027a <stat>:

int
stat(const char *n, struct stat *st)
{
 27a:	1101                	addi	sp,sp,-32
 27c:	ec06                	sd	ra,24(sp)
 27e:	e822                	sd	s0,16(sp)
 280:	e426                	sd	s1,8(sp)
 282:	e04a                	sd	s2,0(sp)
 284:	1000                	addi	s0,sp,32
 286:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 288:	4581                	li	a1,0
 28a:	00000097          	auipc	ra,0x0
 28e:	176080e7          	jalr	374(ra) # 400 <open>
  if(fd < 0)
 292:	02054563          	bltz	a0,2bc <stat+0x42>
 296:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 298:	85ca                	mv	a1,s2
 29a:	00000097          	auipc	ra,0x0
 29e:	17e080e7          	jalr	382(ra) # 418 <fstat>
 2a2:	892a                	mv	s2,a0
  close(fd);
 2a4:	8526                	mv	a0,s1
 2a6:	00000097          	auipc	ra,0x0
 2aa:	142080e7          	jalr	322(ra) # 3e8 <close>
  return r;
}
 2ae:	854a                	mv	a0,s2
 2b0:	60e2                	ld	ra,24(sp)
 2b2:	6442                	ld	s0,16(sp)
 2b4:	64a2                	ld	s1,8(sp)
 2b6:	6902                	ld	s2,0(sp)
 2b8:	6105                	addi	sp,sp,32
 2ba:	8082                	ret
    return -1;
 2bc:	597d                	li	s2,-1
 2be:	bfc5                	j	2ae <stat+0x34>

00000000000002c0 <atoi>:

int
atoi(const char *s)
{
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e422                	sd	s0,8(sp)
 2c4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2c6:	00054603          	lbu	a2,0(a0)
 2ca:	fd06079b          	addiw	a5,a2,-48
 2ce:	0ff7f793          	andi	a5,a5,255
 2d2:	4725                	li	a4,9
 2d4:	02f76963          	bltu	a4,a5,306 <atoi+0x46>
 2d8:	86aa                	mv	a3,a0
  n = 0;
 2da:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2dc:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2de:	0685                	addi	a3,a3,1
 2e0:	0025179b          	slliw	a5,a0,0x2
 2e4:	9fa9                	addw	a5,a5,a0
 2e6:	0017979b          	slliw	a5,a5,0x1
 2ea:	9fb1                	addw	a5,a5,a2
 2ec:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2f0:	0006c603          	lbu	a2,0(a3)
 2f4:	fd06071b          	addiw	a4,a2,-48
 2f8:	0ff77713          	andi	a4,a4,255
 2fc:	fee5f1e3          	bgeu	a1,a4,2de <atoi+0x1e>
  return n;
}
 300:	6422                	ld	s0,8(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret
  n = 0;
 306:	4501                	li	a0,0
 308:	bfe5                	j	300 <atoi+0x40>

000000000000030a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e422                	sd	s0,8(sp)
 30e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 310:	02b57663          	bgeu	a0,a1,33c <memmove+0x32>
    while(n-- > 0)
 314:	02c05163          	blez	a2,336 <memmove+0x2c>
 318:	fff6079b          	addiw	a5,a2,-1
 31c:	1782                	slli	a5,a5,0x20
 31e:	9381                	srli	a5,a5,0x20
 320:	0785                	addi	a5,a5,1
 322:	97aa                	add	a5,a5,a0
  dst = vdst;
 324:	872a                	mv	a4,a0
      *dst++ = *src++;
 326:	0585                	addi	a1,a1,1
 328:	0705                	addi	a4,a4,1
 32a:	fff5c683          	lbu	a3,-1(a1)
 32e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 332:	fee79ae3          	bne	a5,a4,326 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 336:	6422                	ld	s0,8(sp)
 338:	0141                	addi	sp,sp,16
 33a:	8082                	ret
    dst += n;
 33c:	00c50733          	add	a4,a0,a2
    src += n;
 340:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 342:	fec05ae3          	blez	a2,336 <memmove+0x2c>
 346:	fff6079b          	addiw	a5,a2,-1
 34a:	1782                	slli	a5,a5,0x20
 34c:	9381                	srli	a5,a5,0x20
 34e:	fff7c793          	not	a5,a5
 352:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 354:	15fd                	addi	a1,a1,-1
 356:	177d                	addi	a4,a4,-1
 358:	0005c683          	lbu	a3,0(a1)
 35c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 360:	fee79ae3          	bne	a5,a4,354 <memmove+0x4a>
 364:	bfc9                	j	336 <memmove+0x2c>

0000000000000366 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 366:	1141                	addi	sp,sp,-16
 368:	e422                	sd	s0,8(sp)
 36a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 36c:	ca05                	beqz	a2,39c <memcmp+0x36>
 36e:	fff6069b          	addiw	a3,a2,-1
 372:	1682                	slli	a3,a3,0x20
 374:	9281                	srli	a3,a3,0x20
 376:	0685                	addi	a3,a3,1
 378:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 37a:	00054783          	lbu	a5,0(a0)
 37e:	0005c703          	lbu	a4,0(a1)
 382:	00e79863          	bne	a5,a4,392 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 386:	0505                	addi	a0,a0,1
    p2++;
 388:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 38a:	fed518e3          	bne	a0,a3,37a <memcmp+0x14>
  }
  return 0;
 38e:	4501                	li	a0,0
 390:	a019                	j	396 <memcmp+0x30>
      return *p1 - *p2;
 392:	40e7853b          	subw	a0,a5,a4
}
 396:	6422                	ld	s0,8(sp)
 398:	0141                	addi	sp,sp,16
 39a:	8082                	ret
  return 0;
 39c:	4501                	li	a0,0
 39e:	bfe5                	j	396 <memcmp+0x30>

00000000000003a0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3a0:	1141                	addi	sp,sp,-16
 3a2:	e406                	sd	ra,8(sp)
 3a4:	e022                	sd	s0,0(sp)
 3a6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3a8:	00000097          	auipc	ra,0x0
 3ac:	f62080e7          	jalr	-158(ra) # 30a <memmove>
}
 3b0:	60a2                	ld	ra,8(sp)
 3b2:	6402                	ld	s0,0(sp)
 3b4:	0141                	addi	sp,sp,16
 3b6:	8082                	ret

00000000000003b8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3b8:	4885                	li	a7,1
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3c0:	4889                	li	a7,2
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3c8:	488d                	li	a7,3
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3d0:	4891                	li	a7,4
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <read>:
.global read
read:
 li a7, SYS_read
 3d8:	4895                	li	a7,5
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <write>:
.global write
write:
 li a7, SYS_write
 3e0:	48c1                	li	a7,16
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <close>:
.global close
close:
 li a7, SYS_close
 3e8:	48d5                	li	a7,21
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3f0:	4899                	li	a7,6
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3f8:	489d                	li	a7,7
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <open>:
.global open
open:
 li a7, SYS_open
 400:	48bd                	li	a7,15
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 408:	48c5                	li	a7,17
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 410:	48c9                	li	a7,18
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 418:	48a1                	li	a7,8
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <link>:
.global link
link:
 li a7, SYS_link
 420:	48cd                	li	a7,19
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 428:	48d1                	li	a7,20
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 430:	48a5                	li	a7,9
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <dup>:
.global dup
dup:
 li a7, SYS_dup
 438:	48a9                	li	a7,10
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 440:	48ad                	li	a7,11
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 448:	48b1                	li	a7,12
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 450:	48b5                	li	a7,13
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 458:	48b9                	li	a7,14
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 460:	1101                	addi	sp,sp,-32
 462:	ec06                	sd	ra,24(sp)
 464:	e822                	sd	s0,16(sp)
 466:	1000                	addi	s0,sp,32
 468:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 46c:	4605                	li	a2,1
 46e:	fef40593          	addi	a1,s0,-17
 472:	00000097          	auipc	ra,0x0
 476:	f6e080e7          	jalr	-146(ra) # 3e0 <write>
}
 47a:	60e2                	ld	ra,24(sp)
 47c:	6442                	ld	s0,16(sp)
 47e:	6105                	addi	sp,sp,32
 480:	8082                	ret

0000000000000482 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 482:	7139                	addi	sp,sp,-64
 484:	fc06                	sd	ra,56(sp)
 486:	f822                	sd	s0,48(sp)
 488:	f426                	sd	s1,40(sp)
 48a:	f04a                	sd	s2,32(sp)
 48c:	ec4e                	sd	s3,24(sp)
 48e:	0080                	addi	s0,sp,64
 490:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 492:	c299                	beqz	a3,498 <printint+0x16>
 494:	0805c863          	bltz	a1,524 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 498:	2581                	sext.w	a1,a1
  neg = 0;
 49a:	4881                	li	a7,0
 49c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4a0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4a2:	2601                	sext.w	a2,a2
 4a4:	00000517          	auipc	a0,0x0
 4a8:	44450513          	addi	a0,a0,1092 # 8e8 <digits>
 4ac:	883a                	mv	a6,a4
 4ae:	2705                	addiw	a4,a4,1
 4b0:	02c5f7bb          	remuw	a5,a1,a2
 4b4:	1782                	slli	a5,a5,0x20
 4b6:	9381                	srli	a5,a5,0x20
 4b8:	97aa                	add	a5,a5,a0
 4ba:	0007c783          	lbu	a5,0(a5)
 4be:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4c2:	0005879b          	sext.w	a5,a1
 4c6:	02c5d5bb          	divuw	a1,a1,a2
 4ca:	0685                	addi	a3,a3,1
 4cc:	fec7f0e3          	bgeu	a5,a2,4ac <printint+0x2a>
  if(neg)
 4d0:	00088b63          	beqz	a7,4e6 <printint+0x64>
    buf[i++] = '-';
 4d4:	fd040793          	addi	a5,s0,-48
 4d8:	973e                	add	a4,a4,a5
 4da:	02d00793          	li	a5,45
 4de:	fef70823          	sb	a5,-16(a4)
 4e2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4e6:	02e05863          	blez	a4,516 <printint+0x94>
 4ea:	fc040793          	addi	a5,s0,-64
 4ee:	00e78933          	add	s2,a5,a4
 4f2:	fff78993          	addi	s3,a5,-1
 4f6:	99ba                	add	s3,s3,a4
 4f8:	377d                	addiw	a4,a4,-1
 4fa:	1702                	slli	a4,a4,0x20
 4fc:	9301                	srli	a4,a4,0x20
 4fe:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 502:	fff94583          	lbu	a1,-1(s2)
 506:	8526                	mv	a0,s1
 508:	00000097          	auipc	ra,0x0
 50c:	f58080e7          	jalr	-168(ra) # 460 <putc>
  while(--i >= 0)
 510:	197d                	addi	s2,s2,-1
 512:	ff3918e3          	bne	s2,s3,502 <printint+0x80>
}
 516:	70e2                	ld	ra,56(sp)
 518:	7442                	ld	s0,48(sp)
 51a:	74a2                	ld	s1,40(sp)
 51c:	7902                	ld	s2,32(sp)
 51e:	69e2                	ld	s3,24(sp)
 520:	6121                	addi	sp,sp,64
 522:	8082                	ret
    x = -xx;
 524:	40b005bb          	negw	a1,a1
    neg = 1;
 528:	4885                	li	a7,1
    x = -xx;
 52a:	bf8d                	j	49c <printint+0x1a>

000000000000052c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 52c:	7119                	addi	sp,sp,-128
 52e:	fc86                	sd	ra,120(sp)
 530:	f8a2                	sd	s0,112(sp)
 532:	f4a6                	sd	s1,104(sp)
 534:	f0ca                	sd	s2,96(sp)
 536:	ecce                	sd	s3,88(sp)
 538:	e8d2                	sd	s4,80(sp)
 53a:	e4d6                	sd	s5,72(sp)
 53c:	e0da                	sd	s6,64(sp)
 53e:	fc5e                	sd	s7,56(sp)
 540:	f862                	sd	s8,48(sp)
 542:	f466                	sd	s9,40(sp)
 544:	f06a                	sd	s10,32(sp)
 546:	ec6e                	sd	s11,24(sp)
 548:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 54a:	0005c903          	lbu	s2,0(a1)
 54e:	18090f63          	beqz	s2,6ec <vprintf+0x1c0>
 552:	8aaa                	mv	s5,a0
 554:	8b32                	mv	s6,a2
 556:	00158493          	addi	s1,a1,1
  state = 0;
 55a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 55c:	02500a13          	li	s4,37
      if(c == 'd'){
 560:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 564:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 568:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 56c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 570:	00000b97          	auipc	s7,0x0
 574:	378b8b93          	addi	s7,s7,888 # 8e8 <digits>
 578:	a839                	j	596 <vprintf+0x6a>
        putc(fd, c);
 57a:	85ca                	mv	a1,s2
 57c:	8556                	mv	a0,s5
 57e:	00000097          	auipc	ra,0x0
 582:	ee2080e7          	jalr	-286(ra) # 460 <putc>
 586:	a019                	j	58c <vprintf+0x60>
    } else if(state == '%'){
 588:	01498f63          	beq	s3,s4,5a6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 58c:	0485                	addi	s1,s1,1
 58e:	fff4c903          	lbu	s2,-1(s1)
 592:	14090d63          	beqz	s2,6ec <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 596:	0009079b          	sext.w	a5,s2
    if(state == 0){
 59a:	fe0997e3          	bnez	s3,588 <vprintf+0x5c>
      if(c == '%'){
 59e:	fd479ee3          	bne	a5,s4,57a <vprintf+0x4e>
        state = '%';
 5a2:	89be                	mv	s3,a5
 5a4:	b7e5                	j	58c <vprintf+0x60>
      if(c == 'd'){
 5a6:	05878063          	beq	a5,s8,5e6 <vprintf+0xba>
      } else if(c == 'l') {
 5aa:	05978c63          	beq	a5,s9,602 <vprintf+0xd6>
      } else if(c == 'x') {
 5ae:	07a78863          	beq	a5,s10,61e <vprintf+0xf2>
      } else if(c == 'p') {
 5b2:	09b78463          	beq	a5,s11,63a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5b6:	07300713          	li	a4,115
 5ba:	0ce78663          	beq	a5,a4,686 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5be:	06300713          	li	a4,99
 5c2:	0ee78e63          	beq	a5,a4,6be <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5c6:	11478863          	beq	a5,s4,6d6 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5ca:	85d2                	mv	a1,s4
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	e92080e7          	jalr	-366(ra) # 460 <putc>
        putc(fd, c);
 5d6:	85ca                	mv	a1,s2
 5d8:	8556                	mv	a0,s5
 5da:	00000097          	auipc	ra,0x0
 5de:	e86080e7          	jalr	-378(ra) # 460 <putc>
      }
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	b765                	j	58c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 5e6:	008b0913          	addi	s2,s6,8
 5ea:	4685                	li	a3,1
 5ec:	4629                	li	a2,10
 5ee:	000b2583          	lw	a1,0(s6)
 5f2:	8556                	mv	a0,s5
 5f4:	00000097          	auipc	ra,0x0
 5f8:	e8e080e7          	jalr	-370(ra) # 482 <printint>
 5fc:	8b4a                	mv	s6,s2
      state = 0;
 5fe:	4981                	li	s3,0
 600:	b771                	j	58c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 602:	008b0913          	addi	s2,s6,8
 606:	4681                	li	a3,0
 608:	4629                	li	a2,10
 60a:	000b2583          	lw	a1,0(s6)
 60e:	8556                	mv	a0,s5
 610:	00000097          	auipc	ra,0x0
 614:	e72080e7          	jalr	-398(ra) # 482 <printint>
 618:	8b4a                	mv	s6,s2
      state = 0;
 61a:	4981                	li	s3,0
 61c:	bf85                	j	58c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 61e:	008b0913          	addi	s2,s6,8
 622:	4681                	li	a3,0
 624:	4641                	li	a2,16
 626:	000b2583          	lw	a1,0(s6)
 62a:	8556                	mv	a0,s5
 62c:	00000097          	auipc	ra,0x0
 630:	e56080e7          	jalr	-426(ra) # 482 <printint>
 634:	8b4a                	mv	s6,s2
      state = 0;
 636:	4981                	li	s3,0
 638:	bf91                	j	58c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 63a:	008b0793          	addi	a5,s6,8
 63e:	f8f43423          	sd	a5,-120(s0)
 642:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 646:	03000593          	li	a1,48
 64a:	8556                	mv	a0,s5
 64c:	00000097          	auipc	ra,0x0
 650:	e14080e7          	jalr	-492(ra) # 460 <putc>
  putc(fd, 'x');
 654:	85ea                	mv	a1,s10
 656:	8556                	mv	a0,s5
 658:	00000097          	auipc	ra,0x0
 65c:	e08080e7          	jalr	-504(ra) # 460 <putc>
 660:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 662:	03c9d793          	srli	a5,s3,0x3c
 666:	97de                	add	a5,a5,s7
 668:	0007c583          	lbu	a1,0(a5)
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	df2080e7          	jalr	-526(ra) # 460 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 676:	0992                	slli	s3,s3,0x4
 678:	397d                	addiw	s2,s2,-1
 67a:	fe0914e3          	bnez	s2,662 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 67e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 682:	4981                	li	s3,0
 684:	b721                	j	58c <vprintf+0x60>
        s = va_arg(ap, char*);
 686:	008b0993          	addi	s3,s6,8
 68a:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 68e:	02090163          	beqz	s2,6b0 <vprintf+0x184>
        while(*s != 0){
 692:	00094583          	lbu	a1,0(s2)
 696:	c9a1                	beqz	a1,6e6 <vprintf+0x1ba>
          putc(fd, *s);
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	dc6080e7          	jalr	-570(ra) # 460 <putc>
          s++;
 6a2:	0905                	addi	s2,s2,1
        while(*s != 0){
 6a4:	00094583          	lbu	a1,0(s2)
 6a8:	f9e5                	bnez	a1,698 <vprintf+0x16c>
        s = va_arg(ap, char*);
 6aa:	8b4e                	mv	s6,s3
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	bdf9                	j	58c <vprintf+0x60>
          s = "(null)";
 6b0:	00000917          	auipc	s2,0x0
 6b4:	23090913          	addi	s2,s2,560 # 8e0 <malloc+0xea>
        while(*s != 0){
 6b8:	02800593          	li	a1,40
 6bc:	bff1                	j	698 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6be:	008b0913          	addi	s2,s6,8
 6c2:	000b4583          	lbu	a1,0(s6)
 6c6:	8556                	mv	a0,s5
 6c8:	00000097          	auipc	ra,0x0
 6cc:	d98080e7          	jalr	-616(ra) # 460 <putc>
 6d0:	8b4a                	mv	s6,s2
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	bd65                	j	58c <vprintf+0x60>
        putc(fd, c);
 6d6:	85d2                	mv	a1,s4
 6d8:	8556                	mv	a0,s5
 6da:	00000097          	auipc	ra,0x0
 6de:	d86080e7          	jalr	-634(ra) # 460 <putc>
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	b565                	j	58c <vprintf+0x60>
        s = va_arg(ap, char*);
 6e6:	8b4e                	mv	s6,s3
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	b54d                	j	58c <vprintf+0x60>
    }
  }
}
 6ec:	70e6                	ld	ra,120(sp)
 6ee:	7446                	ld	s0,112(sp)
 6f0:	74a6                	ld	s1,104(sp)
 6f2:	7906                	ld	s2,96(sp)
 6f4:	69e6                	ld	s3,88(sp)
 6f6:	6a46                	ld	s4,80(sp)
 6f8:	6aa6                	ld	s5,72(sp)
 6fa:	6b06                	ld	s6,64(sp)
 6fc:	7be2                	ld	s7,56(sp)
 6fe:	7c42                	ld	s8,48(sp)
 700:	7ca2                	ld	s9,40(sp)
 702:	7d02                	ld	s10,32(sp)
 704:	6de2                	ld	s11,24(sp)
 706:	6109                	addi	sp,sp,128
 708:	8082                	ret

000000000000070a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 70a:	715d                	addi	sp,sp,-80
 70c:	ec06                	sd	ra,24(sp)
 70e:	e822                	sd	s0,16(sp)
 710:	1000                	addi	s0,sp,32
 712:	e010                	sd	a2,0(s0)
 714:	e414                	sd	a3,8(s0)
 716:	e818                	sd	a4,16(s0)
 718:	ec1c                	sd	a5,24(s0)
 71a:	03043023          	sd	a6,32(s0)
 71e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 722:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 726:	8622                	mv	a2,s0
 728:	00000097          	auipc	ra,0x0
 72c:	e04080e7          	jalr	-508(ra) # 52c <vprintf>
}
 730:	60e2                	ld	ra,24(sp)
 732:	6442                	ld	s0,16(sp)
 734:	6161                	addi	sp,sp,80
 736:	8082                	ret

0000000000000738 <printf>:

void
printf(const char *fmt, ...)
{
 738:	711d                	addi	sp,sp,-96
 73a:	ec06                	sd	ra,24(sp)
 73c:	e822                	sd	s0,16(sp)
 73e:	1000                	addi	s0,sp,32
 740:	e40c                	sd	a1,8(s0)
 742:	e810                	sd	a2,16(s0)
 744:	ec14                	sd	a3,24(s0)
 746:	f018                	sd	a4,32(s0)
 748:	f41c                	sd	a5,40(s0)
 74a:	03043823          	sd	a6,48(s0)
 74e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 752:	00840613          	addi	a2,s0,8
 756:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 75a:	85aa                	mv	a1,a0
 75c:	4505                	li	a0,1
 75e:	00000097          	auipc	ra,0x0
 762:	dce080e7          	jalr	-562(ra) # 52c <vprintf>
}
 766:	60e2                	ld	ra,24(sp)
 768:	6442                	ld	s0,16(sp)
 76a:	6125                	addi	sp,sp,96
 76c:	8082                	ret

000000000000076e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 76e:	1141                	addi	sp,sp,-16
 770:	e422                	sd	s0,8(sp)
 772:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 774:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 778:	00000797          	auipc	a5,0x0
 77c:	1887b783          	ld	a5,392(a5) # 900 <freep>
 780:	a805                	j	7b0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 782:	4618                	lw	a4,8(a2)
 784:	9db9                	addw	a1,a1,a4
 786:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 78a:	6398                	ld	a4,0(a5)
 78c:	6318                	ld	a4,0(a4)
 78e:	fee53823          	sd	a4,-16(a0)
 792:	a091                	j	7d6 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 794:	ff852703          	lw	a4,-8(a0)
 798:	9e39                	addw	a2,a2,a4
 79a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 79c:	ff053703          	ld	a4,-16(a0)
 7a0:	e398                	sd	a4,0(a5)
 7a2:	a099                	j	7e8 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a4:	6398                	ld	a4,0(a5)
 7a6:	00e7e463          	bltu	a5,a4,7ae <free+0x40>
 7aa:	00e6ea63          	bltu	a3,a4,7be <free+0x50>
{
 7ae:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b0:	fed7fae3          	bgeu	a5,a3,7a4 <free+0x36>
 7b4:	6398                	ld	a4,0(a5)
 7b6:	00e6e463          	bltu	a3,a4,7be <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ba:	fee7eae3          	bltu	a5,a4,7ae <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7be:	ff852583          	lw	a1,-8(a0)
 7c2:	6390                	ld	a2,0(a5)
 7c4:	02059713          	slli	a4,a1,0x20
 7c8:	9301                	srli	a4,a4,0x20
 7ca:	0712                	slli	a4,a4,0x4
 7cc:	9736                	add	a4,a4,a3
 7ce:	fae60ae3          	beq	a2,a4,782 <free+0x14>
    bp->s.ptr = p->s.ptr;
 7d2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7d6:	4790                	lw	a2,8(a5)
 7d8:	02061713          	slli	a4,a2,0x20
 7dc:	9301                	srli	a4,a4,0x20
 7de:	0712                	slli	a4,a4,0x4
 7e0:	973e                	add	a4,a4,a5
 7e2:	fae689e3          	beq	a3,a4,794 <free+0x26>
  } else
    p->s.ptr = bp;
 7e6:	e394                	sd	a3,0(a5)
  freep = p;
 7e8:	00000717          	auipc	a4,0x0
 7ec:	10f73c23          	sd	a5,280(a4) # 900 <freep>
}
 7f0:	6422                	ld	s0,8(sp)
 7f2:	0141                	addi	sp,sp,16
 7f4:	8082                	ret

00000000000007f6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7f6:	7139                	addi	sp,sp,-64
 7f8:	fc06                	sd	ra,56(sp)
 7fa:	f822                	sd	s0,48(sp)
 7fc:	f426                	sd	s1,40(sp)
 7fe:	f04a                	sd	s2,32(sp)
 800:	ec4e                	sd	s3,24(sp)
 802:	e852                	sd	s4,16(sp)
 804:	e456                	sd	s5,8(sp)
 806:	e05a                	sd	s6,0(sp)
 808:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 80a:	02051493          	slli	s1,a0,0x20
 80e:	9081                	srli	s1,s1,0x20
 810:	04bd                	addi	s1,s1,15
 812:	8091                	srli	s1,s1,0x4
 814:	0014899b          	addiw	s3,s1,1
 818:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 81a:	00000517          	auipc	a0,0x0
 81e:	0e653503          	ld	a0,230(a0) # 900 <freep>
 822:	c515                	beqz	a0,84e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 824:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 826:	4798                	lw	a4,8(a5)
 828:	02977f63          	bgeu	a4,s1,866 <malloc+0x70>
 82c:	8a4e                	mv	s4,s3
 82e:	0009871b          	sext.w	a4,s3
 832:	6685                	lui	a3,0x1
 834:	00d77363          	bgeu	a4,a3,83a <malloc+0x44>
 838:	6a05                	lui	s4,0x1
 83a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 83e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 842:	00000917          	auipc	s2,0x0
 846:	0be90913          	addi	s2,s2,190 # 900 <freep>
  if(p == (char*)-1)
 84a:	5afd                	li	s5,-1
 84c:	a88d                	j	8be <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 84e:	00000797          	auipc	a5,0x0
 852:	0ba78793          	addi	a5,a5,186 # 908 <base>
 856:	00000717          	auipc	a4,0x0
 85a:	0af73523          	sd	a5,170(a4) # 900 <freep>
 85e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 860:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 864:	b7e1                	j	82c <malloc+0x36>
      if(p->s.size == nunits)
 866:	02e48b63          	beq	s1,a4,89c <malloc+0xa6>
        p->s.size -= nunits;
 86a:	4137073b          	subw	a4,a4,s3
 86e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 870:	1702                	slli	a4,a4,0x20
 872:	9301                	srli	a4,a4,0x20
 874:	0712                	slli	a4,a4,0x4
 876:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 878:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 87c:	00000717          	auipc	a4,0x0
 880:	08a73223          	sd	a0,132(a4) # 900 <freep>
      return (void*)(p + 1);
 884:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 888:	70e2                	ld	ra,56(sp)
 88a:	7442                	ld	s0,48(sp)
 88c:	74a2                	ld	s1,40(sp)
 88e:	7902                	ld	s2,32(sp)
 890:	69e2                	ld	s3,24(sp)
 892:	6a42                	ld	s4,16(sp)
 894:	6aa2                	ld	s5,8(sp)
 896:	6b02                	ld	s6,0(sp)
 898:	6121                	addi	sp,sp,64
 89a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 89c:	6398                	ld	a4,0(a5)
 89e:	e118                	sd	a4,0(a0)
 8a0:	bff1                	j	87c <malloc+0x86>
  hp->s.size = nu;
 8a2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8a6:	0541                	addi	a0,a0,16
 8a8:	00000097          	auipc	ra,0x0
 8ac:	ec6080e7          	jalr	-314(ra) # 76e <free>
  return freep;
 8b0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8b4:	d971                	beqz	a0,888 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b8:	4798                	lw	a4,8(a5)
 8ba:	fa9776e3          	bgeu	a4,s1,866 <malloc+0x70>
    if(p == freep)
 8be:	00093703          	ld	a4,0(s2)
 8c2:	853e                	mv	a0,a5
 8c4:	fef719e3          	bne	a4,a5,8b6 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 8c8:	8552                	mv	a0,s4
 8ca:	00000097          	auipc	ra,0x0
 8ce:	b7e080e7          	jalr	-1154(ra) # 448 <sbrk>
  if(p == (char*)-1)
 8d2:	fd5518e3          	bne	a0,s5,8a2 <malloc+0xac>
        return 0;
 8d6:	4501                	li	a0,0
 8d8:	bf45                	j	888 <malloc+0x92>
