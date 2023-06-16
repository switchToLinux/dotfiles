# mpd配置说明


## 源码编译mpd


### libmpcdec版本陈旧问题

编译时遇到这个问题:
```
../../src/decoder/plugins/MpcdecDecoderPlugin.cxx:15:10: 致命错误：mpc/mpcdec.h：没有那个文件或目录
   15 | #include <mpc/mpcdec.h>
      |          ^~~~~~~~~~~~~~
编译中断。

```
发现安装的 `libmpcdec-devel`版本是`1.2.6` 找不到 `mpc/mpcdec.h`，应该使用最新版本， 而在 `openSUSE`上最新版本名称为`musepack`.
安装方法:
```sh
$ sudo zypper in musepack musepack-devel

$ ll /usr/include/mpc/mpcdec.h
-rw-r--r-- 1 root root 5.9K  2月 24  2009 /usr/include/mpc/mpcdec.h
```
安装成功，找到 `mpc/mpcdec.h`文件了。


### 第二个问题

```
In file included from ../../src/decoder/plugins/SndfileDecoderPlugin.cxx:15:
/usr/include/
   21 | typedef const BYTE * LPCBYTE;


```

源码编译安装:
```sh

git clone https://github.com/libsndfile/libsndfile.git

```

报错 libmodplug/sndfile.h 

```
In file included from ../../src/decoder/plugins/SndfileDecoderPlugin.cxx:15:
/usr/include/libmodplug/sndfile.h:21:15: 错误：‘BYTE’不是一个类型名
   21 | typedef const BYTE * LPCBYTE;

```

修改了下 `meson.build` 配置文件:
```
 common_cppflags = [
-  '-D_GNU_SOURCE',
+  '-D_GNU_SOURCE','-static'
 ]
 
 test_global_common_flags = [
-  '-fvisibility=hidden',
+  '-fvisibility=hidden','-static'
 ]
 
```

编译成功，输出结果如下:

```
Found ninja-1.10.0 at /usr/bin/ninja
Cleaning... 0 files.
[696/697] Generating doc/HTML documentation with a custom command
WARNING: 不支持的主题选项 'github_url'
/apps/code/github/music/MPD/doc/user.rst:1329: WARNING: unknown option: --verbose
/apps/code/github/music/MPD/doc/user.rst:1422: WARNING: unknown option: --verbose
[697/697] Linking target mpd
/usr/bin/ld: warning: libavcodec.so.57, needed by /usr/lib64/libchromaprint.so, may conflict with libavcodec.so.59
/usr/bin/ld: warning: libavutil.so.55, needed by /usr/lib64/libchromaprint.so, may conflict with libavutil.so.57
/usr/bin/ld: warning: libcdio.so.16, needed by /usr/lib64/libcdio_paranoia.so, may conflict with libcdio.so.19

```

---