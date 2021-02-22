@echo off

SET LLVM_DIR=llvm
SET CLANG_DIR=clang
SET BUILD_DIR=build

SET BUILD_TYPE=Release

IF not EXIST %LLVM_DIR% (
	echo ERROR: Couldn't find LLVM directory at %LLVM_DIR% 
	EXIT /B 1
)

IF not EXIST %CLANG_DIR% (
	echo ERROR: Couldn't find CLang directory at %CLANG_DIR% 
	EXIT /B 1
)

IF EXIST %BUILD_DIR% (
	echo Found build folder at %BUILD_DIR%. Will attempt to overwrite files
) ELSE (
	mkdir %BUILD_DIR%
)

cd %BUILD_DIR%

:: Building with Ninja (faster)
CALL "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\Common7\Tools\VsDevCmd.bat" -host_arch=amd64 -arch=amd64
cmake -G "Ninja" -DCMAKE_BUILD_TYPE=%BUILD_TYPE% -DLLVM_BUILD_LLVM_C_DYLIB=OFF -DLLVM_OPTIMIZED_TABLEGEN=ON -DLLVM_PARALLEL_LINK_JOBS=2 -DLLVM_ENABLE_PROJECTS=clang "..\%LLVM_DIR%"
ninja -j8 clang

:: Building with MSVC
::cmake -G "Visual Studio 16 2019" -DLLVM_ENABLE_PROJECTS='clang' -A x64 -Thost=x64 "..\%LLVM_DIR%"
::cmake --build .
