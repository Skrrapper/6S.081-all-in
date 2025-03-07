#define T_DIR     1   // Directory
#define T_FILE    2   // File
#define T_DEVICE  3   // Device

//用来定义文件的一系列属性
struct stat {
  int dev;     // 文件的设备号
  uint ino;    // Inode number
  short type;  // Type of file
  short nlink; // Number of links to file
  uint64 size; // Size of file in bytes
};
