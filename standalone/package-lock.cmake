# CPM Package Lock This file should be committed to version control

# Ccache.cmake
CPMDeclarePackage(
  Ccache.cmake
  NAME
  Ccache.cmake
  VERSION
  1.2.1
  GITHUB_REPOSITORY
  TheLartians/Ccache.cmake
)
# cxxopts
CPMDeclarePackage(
  cxxopts
  NAME
  cxxopts
  VERSION
  2.2.0
  GITHUB_REPOSITORY
  jarro2783/cxxopts
  OPTIONS
  "CXXOPTS_BUILD_EXAMPLES Off"
  "CXXOPTS_BUILD_TESTS Off"
)
# Greeter (unversioned) CPMDeclarePackage(Greeter local directory ) PackageProject.cmake
CPMDeclarePackage(
  PackageProject.cmake
  NAME
  PackageProject.cmake
  VERSION
  1.4.1
  GITHUB_REPOSITORY
  TheLartians/PackageProject.cmake
)
# fmt
CPMDeclarePackage(
  fmt
  NAME
  fmt
  GIT_TAG
  7.1.3
  GITHUB_REPOSITORY
  fmtlib/fmt
  OPTIONS
  "FMT_INSTALL YES"
)
