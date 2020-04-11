[![Actions Status](https://github.com/TheLartians/Greeter/workflows/MacOS/badge.svg)](https://github.com/TheLartians/Greeter/actions)
[![Actions Status](https://github.com/TheLartians/Greeter/workflows/Windows/badge.svg)](https://github.com/TheLartians/Greeter/actions)
[![Actions Status](https://github.com/TheLartians/Greeter/workflows/Ubuntu/badge.svg)](https://github.com/TheLartians/Greeter/actions)
[![Actions Status](https://github.com/TheLartians/Greeter/workflows/Style/badge.svg)](https://github.com/TheLartians/Greeter/actions)

# Greeter

A best-practice git template for modern C++ libraries and projects.

## Features

- Modern CMakeLists.txt
- Suited for single header libraries and larger projects
- Creates a library that can be installed or included locally
- Integrated test suite
- Code formatting enforced via [clang-format](https://clang.llvm.org/docs/ClangFormat.html)/[Format.cmake](https://github.com/TheLartians/Format.cmake)
- Continuous integration via GitHub Workflows
- Reliable dependency management via [CPM.cmake](https://github.com/TheLartians/CPM.cmake)
- Check compiler warnings

## Roadmap

- Add code coverage checks
- Add a script to automatically rename project / switch to single-header mode
 
## Usage

### Adjust the template to your needs

- Clone this repo and replace all occurrences of "Greeter" in the [CMakeLists.txt](CMakeLists.txt)
- Single-header libraries: see the comments in [CMakeLists.txt](CMakeLists.txt)
- Have fun!

### Build and run test suite

```bash
cmake -Htest -Bbuild
cmake --build build
CTEST_OUTPUT_ON_FAILURE=1 cmake --build build --target test
# or simply call the executable: 
./build/GreeterTests
```

### Run clang-format

```bash
cmake -Htest -Bbuild
# view changes
cmake --build build --target format
# apply changes
cmake --build build --target fix-format
```

See [Format.cmake](https://github.com/TheLartians/Format.cmake) for more options.
