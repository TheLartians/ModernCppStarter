[![Actions Status](https://github.com/TheLartians/Greeter/workflows/MacOS/badge.svg)](https://github.com/TheLartians/Greeter/actions)
[![Actions Status](https://github.com/TheLartians/Greeter/workflows/Windows/badge.svg)](https://github.com/TheLartians/Greeter/actions)
[![Actions Status](https://github.com/TheLartians/Greeter/workflows/Ubuntu/badge.svg)](https://github.com/TheLartians/Greeter/actions)
[![Actions Status](https://github.com/TheLartians/Greeter/workflows/Style/badge.svg)](https://github.com/TheLartians/Greeter/actions)

# CMakeStarter

A template for modern C++ libraries and projects.

## Features

- Modern CMake practices
- Suited for single header libraries and larger projects
- Integrated test suite
- Preconfigured for continuous integration with multiplatform tests via GitHub Workflows
- Code formatting enforced via [clang-format](https://clang.llvm.org/docs/ClangFormat.html)/[Format.cmake](https://github.com/TheLartians/Format.cmake)
- Reliable dependency management that works everywhere via [CPM.cmake](https://github.com/TheLartians/CPM.cmake)

## Usage

### Adjust the template to your needs

- Clone this repo and replace all occurrences of "Greeter" in the [CMakeLists.txt](CMakeLists.txt) with the name of your project
- Replace the source files with your own
- For single-header libraries: see the comments in [CMakeLists.txt](CMakeLists.txt)
- Have fun!

### Build and run test suite

Use the following commands from the project's root directory to run the test suite.

```bash
cmake -Htest -Bbuild
cmake --build build
CTEST_OUTPUT_ON_FAILURE=1 cmake --build build --target test
# or simply call the executable: 
./build/GreeterTests
```

### Run clang-format

Use the following commands from the project's root directory to run clang-format (must be installed on the host system).

```bash
cmake -Htest -Bbuild
# view changes
cmake --build build --target format
# apply changes
cmake --build build --target fix-format
```

See [Format.cmake](https://github.com/TheLartians/Format.cmake) for more options.

## Coming soon

- Code coverage

