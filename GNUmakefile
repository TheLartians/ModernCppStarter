#

#XXX GENERATOR?="Unix Makefiles"
GENERATOR?=Ninja

STAGE_DIR?=$(CURDIR)/stage
BUILD_TYPE?=Debug
CMAKE_PRESET:=-G "$(GENERATOR)" -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -DCMAKE_PREFIX_PATH=$(STAGE_DIR)
# Note: not needed -DCMAKE_CXX_COMPILER_LAUNCHER=ccache

#XXX export CXX=clang++
export CPM_USE_LOCAL_PACKAGES=0
export CPM_SOURCE_CACHE=${HOME}/.cache/CPM

PROJECT_NAME:=$(shell basename $(CURDIR))
BUILD_DIR?=../build-$(PROJECT_NAME)-$(CXX)-$(BUILD_TYPE)

.PHONY: update format all test standalone doc check clean distclean

# the default target does just all, but neither standalone nor doc
test:

clean:
	rm -rf $(BUILD_DIR) build build-*

distclean: clean
	rm -rf $(STAGE_DIR)

# update CPM.cmake
update:
	wget -q -O cmake/CPM.cmake https://github.com/cpm-cmake/CPM.cmake/releases/latest/download/get_cpm.cmake
	wget -q -O cmake/WarningsAsErrors.cmake https://raw.githubusercontent.com/approvals/ApprovalTests.cpp/master/CMake/WarningsAsErrors.cmake

# install the library to stagedir
install:
	cmake -S . -B $(BUILD_DIR)/$@ ${CMAKE_PRESET} -DCMAKE_INSTALL_PREFIX=$(STAGE_DIR) -DCMAKE_CXX_STANDARD=20 #NO! -DCMAKE_CXX_CLANG_TIDY=clang-tidy # --trace-expand
	cmake --build $(BUILD_DIR)/$@ --target $@
	perl -i.bak -pe 's#-I($$CPM_SOURCE_CACHE)#-isystem $$1#g' $(BUILD_DIR)/$@/compile_commands.json
	run-clang-tidy.py -p $(BUILD_DIR)/$@ -quiet -header-filter='$(CURDIR)/.*' source    # Note: only local sources! CK

# test the library
test: install
	cmake -S $@ -B $(BUILD_DIR)/$@ ${CMAKE_PRESET} -DTEST_INSTALLED_VERSION=1
	perl -i.bak -pe 's#-I($$CPM_SOURCE_CACHE)#-isystem $$1#g' $(BUILD_DIR)/$@/compile_commands.json
	cmake --build $(BUILD_DIR)/$@
	cmake --build $(BUILD_DIR)/$@ --target $@
	run-clang-tidy.py -p $(BUILD_DIR)/$@ -quiet -header-filter='$(CURDIR)/.*' test/source    # Note: only local sources! CK

# all together
all:
	cmake -S $@ -B $(BUILD_DIR)/$@ ${CMAKE_PRESET} -DENABLE_TEST_COVERAGE=1 # Note: NO! -DUSE_STATIC_ANALYZER=clang-tidy CK
	cmake --build $(BUILD_DIR)/$@
	cmake --build $(BUILD_DIR)/$@ --target test

# GenerateDocs
doc:
	cmake -S documentation -B $(BUILD_DIR)/documentation ${CMAKE_PRESET}
	cmake --build $(BUILD_DIR)/documentation --target GenerateDocs

format: distclean
	find . -name CMakeLists.txt | xargs cmake-format -i
	find . -type f -name '*.cmake' | xargs cmake-format -i
	find . -name '*.cpp' | xargs clang-format -i
	find . -name '*.h' | xargs clang-format -i

standalone:
	cmake -S $@ -B $(BUILD_DIR)/$@ ${CMAKE_PRESET}
	perl -i.bak -pe 's#-I($$CPM_SOURCE_CACHE)#-isystem $$1#g' $(BUILD_DIR)/$@/compile_commands.json
	cmake --build $(BUILD_DIR)/$@

# check the library
check: standalone
	run-clang-tidy.py -p $(BUILD_DIR)/standalone -quiet -header-filter='$(CURDIR)/.*' -checks='-*,modernize-*,misc-*,hicpp-*,cert-*,readability-*,portability-*,performance-*,google-*' standalone
