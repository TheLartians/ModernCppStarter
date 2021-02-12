# CPM Package Lock This file should be committed to version control

# PackageProject.cmake
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
