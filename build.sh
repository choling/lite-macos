#!/bin/bash

cflags="-Wall -O3 -g -std=gnu11 -fno-strict-aliasing -Isrc"
lflags="-lSDL2 -lm"

if [[ $* == *windows* ]]; then
  platform="windows"
  outfile="lite.exe"
  compiler="x86_64-w64-mingw32-gcc"
  cflags="$cflags -DLUA_USE_POPEN -Iwinlib/SDL2-2.0.10/x86_64-w64-mingw32/include"
  lflags="$lflags -Lwinlib/SDL2-2.0.10/x86_64-w64-mingw32/lib"
  lflags="-lmingw32 -lSDL2main $lflags -mwindows -o $outfile res.res"
  x86_64-w64-mingw32-windres res.rc -O coff -o res.res
elif [[ $* == *macos* ]]; then
  platform="macos"
  outfile="lite"
  compiler="gcc"
  cflags="$cflags -DLUA_USE_POSIX"
  lflags="-D_THREAD_SAFE -I/usr/local/include/SDL2 -L/usr/local/lib -lSDL2 -framework Foundation -lobjc -lm -o $outfile"
else
  platform="unix"
  outfile="lite"
  compiler="gcc"
  cflags="$cflags -DLUA_USE_POSIX"
  lflags="$lflags -o $outfile"
fi

if command -v ccache >/dev/null; then
  compiler="ccache $compiler"
fi


echo "compiling ($platform)..."
for f in `find src -name "*.c" -or -name "*.m"`; do
  $compiler -c $cflags $f -o "${f//\//_}.o"
  if [[ $? -ne 0 ]]; then
    got_error=true
  fi
done

if [[ ! $got_error ]]; then
  echo "linking..."
  $compiler *.o $lflags
fi

echo "cleaning up..."
rm *.o
rm res.res 2>/dev/null
echo "done"
