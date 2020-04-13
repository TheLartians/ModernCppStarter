[![Actions Status](https://github.com/TheLartians/ModernCPPStarter/workflows/MacOS/badge.svg)](https://github.com/TheLartians/Greeter/actions)
[![Actions Status](https://github.com/TheLartians/ModernCPPStarter/workflows/Windows/badge.svg)](https://github.com/TheLartians/Greeter/actions)
[![Actions Status](https://github.com/TheLartians/ModernCPPStarter/workflows/Ubuntu/badge.svg)](https://github.com/TheLartians/Greeter/actions)
[![Actions Status](https://github.com/TheLartians/ModernCPPStarter/workflows/Style/badge.svg)](https://github.com/TheLartians/Greeter/actions)
[![Actions Status](https://github.com/TheLartians/ModernCPPStarter/workflows/Install/badge.svg)](https://github.com/TheLartians/Greeter/actions)
[![codecov](https://codecov.io/gh/TheLartians/ModernCPPStarter/branch/master/graph/badge.svg)](https://codecov.io/gh/TheLartians/ModernCPPStarter)

# ModernCPPStarter

A template for starting modern C++ libraries and projects.
Setting up a new C++ project usually requires a significant amount of preparation and boilerplate code.
Even more so for modern C++ projects with tests and contiguous integration.
This template is a collection from learnings of previous projects and should allow quick setting up new modern C++ projects.

## Features

- Modern CMake practices
- Suited for single header libraries and larger projects
- Integrated test suite
- Continuous integration via [GitHub Actions](https://help.github.com/en/actions/)
- Code coverage via [codecov](https://codecov.io)
- Code formatting enforced by [clang-format](https://clang.llvm.org/docs/ClangFormat.html) via [Format.cmake](https://github.com/TheLartians/Format.cmake)
- Reproducible dependency management via [CPM.cmake](https://github.com/TheLartians/CPM.cmake)

## Usage

### Adjust the template to your needs

- Clone this repo and replace all occurrences of "Greeter" in the [CMakeLists.txt](CMakeLists.txt) with the name of your project
- Replace the source files with your own
- For single-header libraries: see the comments in [CMakeLists.txt](CMakeLists.txt)
- Add your codecov token in the [ubuntu workflow](.github/workflows/ubuntu.yml) or remove the codecov step
- Happy coding!

### Build and run test suite

Use the following commands from the project's root directory to run the test suite.

```bash
cmake -Htest -Bbuild
cmake --build build
CTEST_OUTPUT_ON_FAILURE=1 cmake --build build --target test
# or simply call the executable: 
./build/GreeterTests
```

To collect code coverage information, run CMake with the `-DENABLE_TEST_COVERAGE=1` option.

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

## FAQ

  - Can I use this for header-only libraries?

    Yes, however you will need to change the library type to an `INTERFACE` library as documented in the [CMakeLists.txt](CMakeLists.txt).

  - You are using `GLOB` to add source files in CMakeLists.txt. Isn't that evil?

    Glob is considered bad because changes to source files won't be automatically caught by CMakes builders and you will need remember to invoke CMake on any changes.
    I personally prefer the `GLOB` solution for its simplicity, but feel free to change it to explicitly listing sources.

  - I'm adding external dependencies to my project using CPM. Will this force users to use CPM as well?

    CPM should be mostly invisible for your library users as it's self-contained and dependency free.
    If problems do arise, they can always opt-out by defining `CPM_USE_LOCAL_PACKAGES`, which will override all calls to `CPMAddPackage` with `find_package`.
    If you are using `CPMFindPackage` instead of `CPMAddPackage`, CPM will always try to use `find_package` to add packages.
    This approach should be compatible with any common C++ package manager without any user intervention, however at the cost of reproducible builds.

## Coming soon

- Script to automatically update project-specific settings
