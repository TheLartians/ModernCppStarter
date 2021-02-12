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
# doctest
CPMDeclarePackage(
  doctest
  NAME
  doctest
  GIT_TAG
  2.4.5
  GITHUB_REPOSITORY
  onqtam/doctest
)
# Format.cmake
CPMDeclarePackage(
  Format.cmake
  NAME
  Format.cmake
  VERSION
  1.6
  GITHUB_REPOSITORY
  TheLartians/Format.cmake
  OPTIONS
  "FORMAT_CHECK_CMAKE ON"
)
