[![Actions Status](https://github.com/TheLartians/ModernCPPStarter/workflows/MacOS/badge.svg)](https://github.com/TheLartians/ModernCPPStarter/actions)
[![Actions Status](https://github.com/TheLartians/ModernCPPStarter/workflows/Windows/badge.svg)](https://github.com/TheLartians/ModernCPPStarter/actions)
[![Actions Status](https://github.com/TheLartians/ModernCPPStarter/workflows/Ubuntu/badge.svg)](https://github.com/TheLartians/ModernCPPStarter/actions)
[![Actions Status](https://github.com/TheLartians/ModernCPPStarter/workflows/Style/badge.svg)](https://github.com/TheLartians/ModernCPPStarter/actions)
[![Actions Status](https://github.com/TheLartians/ModernCPPStarter/workflows/Install/badge.svg)](https://github.com/TheLartians/ModernCPPStarter/actions)
[![codecov](https://codecov.io/gh/TheLartians/ModernCPPStarter/branch/master/graph/badge.svg)](https://codecov.io/gh/TheLartians/ModernCPPStarter)

# ModernCPPStarter

A template for starting modern C++ libraries and projects.
Setting up a new C++ project usually requires a significant amount of preparation and boilerplate code.
Even more so for modern C++ projects with tests and contiguous integration.
This template is a collection from learnings of previous projects and should allow quick setting up new modern C++ projects.

## Features

- Modern CMake practices
- Suited for single header libraries and projects of any scale
- Separation into library and executable code
- Integrated test suite
- Continuous integration via [GitHub Actions](https://help.github.com/en/actions/)
- Code coverage via [codecov](https://codecov.io)
- Code formatting enforced by [clang-format](https://clang.llvm.org/docs/ClangFormat.html) via [Format.cmake](https://github.com/TheLartians/Format.cmake)
- Reproducible dependency management via [CPM.cmake](https://github.com/TheLartians/CPM.cmake)
- Installable target with versioning information via [PackageProject.cmake](https://github.com/TheLartians/PackageProject.cmake)

## Usage

### Adjust the template to your needs

- Use this repo [as a template](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-repository-from-a-template) and replace all occurrences of "Greeter" in the relevant CMakeLists.txt with the name of your project
- Replace the source files with your own
- For single-header libraries: see the comments in [CMakeLists.txt](CMakeLists.txt)
- Add your project's codecov token to your project's github secrets under `CODECOV_TOKEN`
- Happy coding!

Remember to eventually remove any unused files, such as the standalone directory or irrelevant tests for your project.

### Build and run the standalone target

Use the following command to build and run the executable target.

```bash
cmake -Hstandalone -Bbuild/standalone
cmake --build build/standalone
./build/standalone/Greeter --help
```

### Build and run test suite

Use the following commands from the project's root directory to run the test suite.

```bash
cmake -Htest -Bbuild/test
cmake --build build/test
CTEST_OUTPUT_ON_FAILURE=1 cmake --build build/test --target test

# or simply call the executable: 
./build/test/GreeterTests
```

To collect code coverage information, run CMake with the `-DENABLE_TEST_COVERAGE=1` option.

### Run clang-format

Use the following commands from the project's root directory to run clang-format (must be installed on the host system).

```bash
cmake -Htest -Bbuild/test

# view changes
cmake --build build/test --target format

# apply changes
cmake --build build/test --target fix-format
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
    For more info, see the [CPM.cmake documentation](https://github.com/TheLartians/CPM.cmake).

  - Can I configure and build my project offline?

    Using CPM, all missing dependencies are downloaded at configure time.
    To avoid redundant downloads, it's recommended to set a CPM cache directory, e.g.: `export CPM_SOURCE_CACHE=$HOME/.cache/CPM`.
    This will also allow offline configurations if all dependencies are present.
    No internet connection is required for building.

  - Can I use CPack to create a package installer for my project?

    As there are a lot of possible options and configurations, this is not (yet) in the scope of this template. See the [CPack documentation](https://cmake.org/cmake/help/latest/module/CPack.html) for more information on setting up CPack installers.

## Coming soon

- Script to automatically adjust the template for new projects
