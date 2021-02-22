# Obfvious

Obfvious is a LLVM & Clang (version 12) based compiler that allows for Windows binaries obfuscation.

Obfvious is currently implemented as an integral part of Clang and is invoked automatically as part of the compilation with `clang.exe`.

**Test Pass Status:**
- `check-llvm`: 37990 Passed, 305 Failed
- `clang-test`: 26049 Passed, 387 Failed

## Why?

Obfvious was incepted during my [research on executable similarity](https://nimrodpar.github.io/posts/firmup-paper/). I was contemplating using the technique for malware similarity, and wanted to examine how reliant are static AV engines (exposed through VirusTotal (TM)) on meta data such as hard-coded strings and debug info.

I open sourced Obfvious as a tool for other researchers interested in binary and malware analysis.

## Compiling on Win 10

**Prerequisites:**
* Install Build Tools for VS from [here](https://visualstudio.microsoft.com/downloads/#) (check the “C++ build tools” box and under the “Installation details” may want to also check ‘C++ ATL’ box).
    * You can install it via command line by downloading https://aka.ms/vs/16/release/vs_buildtools.exe and running `vs_buildtools.exe --quiet --wait --norestart --nocache  --add 	Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.ATLMFC --includeRecommended`
* Install Git, CMake and Python3, make sure they are added to path.
    * [Unchecked] You can install deps using Chocolatey:
        * Install choco from powershell: `iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))`
        * `choco install cmake git python3 --installargs '"ADD_CMAKE_TO_PATH=System"'` (You may still need to add them it manually to PATH)
* Clone the Obfvious repo `git clone --config core.autocrlf=false https://github.com/nimrodpar/Obfvious.git`

**Build:**
* Open a `cmd.exe` and run `build.bat`. You can rebuild under the same shell by invoking `ninja clang`
* To (re)build in a new shell, open a `cmd.exe`, run `env.bat`, `cd` into `build` and `ninja clang`

**Test:**
* Testing requires grep and sed, you can install them with chocolatey `choco install grep sed`
* Open a `cmd.exe`, run `env.bat`, `cd` into `build` and `ninja check-llvm clang-test`

## Status & Contributing

Obfvious is in a very initial state, and only allows for basic string obfuscation through RORing with a random value. Decoding is done JIT-style by allocating a string for each usage and decoding the obfuscated string to it (and then reading it).

Although being a trivial transformation, I have yet to find a decent open source tool for doing this. Furthermore, the string transformation seems to be enough to avoid static detection of malware (TODO: cite).

A list of interesting transformation I hope to explore and perhaps implement:
* More string obfuscations through concatenation, whitelist, etc.
* Dead code addition
* Instruction substitution
* Function splitting, cloning and merging.
* Live code addition

**You are very much encouraged to suggest and implement any and all features through issues / pull requests**

The code for Obfvious was added under the `CodeGen` module and is located in files
`clang/lib/CodeGen/ObfviousObfuscator.{h, cpp}`

**License**: Same as LLVM.

## Notes
* As opposed to many tools build upon LLVM, Obfvious is *not* implemented as a pass, but instead coded as an integral part of Clang. To the best of my knowledge, you can’t at this point create an out-of-source LLVM pass on windows.
* You cannot cross compile (you can’t build a Windows clang on a non-Win machine)

## Obfvious on \*nix systems
There is nothing preventing Obfvious from working on Linux and Mac distributions. It should work just fine, I just didn't get around to testing it. 

## Resources
* [LLVM for Grad Students](http://www.cs.cornell.edu/~asampson/blog/llvm.html)
* [Nice Clang overview](https://llvm.org/devmtg/2017-06/2-Hal-Finkel-LLVM-2017.pdf)
* [Writing an LLVM obfuscating pass blog post](https://medium.com/@polarply/build-your-first-llvm-obfuscator-80d16583392b) and [code](https://github.com/tsarpaul/llvm-string-obfuscator/blob/master/StringObfuscator/StringObfuscator.cpp)
* https://llvm.org/docs/ProgrammersManual.html
* https://llvm.org/docs/LangRef.html
* https://llvm.org/docs/GetElementPtr.html
