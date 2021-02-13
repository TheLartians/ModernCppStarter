# CPM Package Lock This file should be committed to version control

# Ccache.cmake
CPMDeclarePackage(
  Ccache.cmake
  NAME Ccache.cmake
  VERSION 1.2.1
  GITHUB_REPOSITORY TheLartians/Ccache.cmake
)
# Format.cmake
CPMDeclarePackage(
  Format.cmake
  NAME Format.cmake
  VERSION 1.6
  GITHUB_REPOSITORY TheLartians/Format.cmake
  OPTIONS "FORMAT_CHECK_CMAKE ON"
)
# MCSS (unversioned) CPMDeclarePackage(MCSS NAME MCSS GIT_TAG
# 42d4a9a48f31f5df6e246c948403b54b50574a2a DOWNLOAD_ONLY YES GITHUB_REPOSITORY mosra/m.css )
