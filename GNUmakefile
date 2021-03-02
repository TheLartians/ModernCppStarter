#
# Note: make var CURDIR:=$(/bin/pwd)
ROOT?=$(CURDIR)/stagedir

#XXX GENERATOR?="Unix Makefiles"
GENERATOR?=Ninja

#XXX export CXX=clang++
export CPM_USE_LOCAL_PACKAGES=0
export CPM_SOURCE_CACHE=${HOME}/.cache/CPM

.PHONY: update format all test standalone doc check clean distclean lock

# the default target does just all, but neither standalone nor doc
all:

clean:
	find . -type d -name build | xargs rm -rf

distclean: clean
	rm -rf build ${ROOT}

# update CPM.cmake
update:
	wget -q -O cmake/CPM.cmake https://github.com/cpm-cmake/CPM.cmake/releases/latest/download/get_cpm.cmake

lock: all standalone doc
	cmake --build build/all --target cpm-update-package-lock
	cmake --build build/test --target cpm-update-package-lock
	cmake --build build/install --target cpm-update-package-lock
	cmake --build build/standalone --target cpm-update-package-lock
	cmake --build build/documentation --target cpm-update-package-lock

# install the library to stagedir
install:
	cmake -S . -B build/$@ -G "${GENERATOR}" -DCMAKE_PREFIX_PATH=${ROOT} -DCMAKE_INSTALL_PREFIX=${ROOT} # --trace-expand
	cmake --build build/$@ --target $@

# test the library
test: install
	cmake -S $@ -B build/$@ -G "${GENERATOR}" -DCMAKE_PREFIX_PATH=${ROOT} -DTEST_INSTALLED_VERSION=1
	cmake --build build/$@
	cmake --build build/$@ --target $@

# all together
all: test
	cmake -S $@ -B build/$@ -G "${GENERATOR}" -DCMAKE_PREFIX_PATH=${ROOT} -DTEST_INSTALLED_VERSION=1 -DENABLE_TEST_COVERAGE=1 -DUSE_STATIC_ANALYZER=clang-tidy
	cmake --build build/$@
	cmake --build build/$@ --target test
	cmake --build build/$@ --target check-format

# GenerateDocs
doc:
	cmake -S documentation -B build/documentation -G "${GENERATOR}"
	cmake --build build/documentation --target GenerateDocs

format: distclean
	find . -name CMakeLists.txt | xargs cmake-format -i
	find . -name '*.cmake' | xargs cmake-format -i
	find . -name '*.cpp' | xargs clang-format -i
	find . -name '*.h' | xargs clang-format -i

standalone:
	cmake -S $@ -B build/$@ -G "${GENERATOR}" -DCMAKE_PREFIX_PATH=${ROOT} -DCMAKE_EXPORT_COMPILE_COMMANDS=1
	cmake --build build/$@

# check the library
check: standalone
	run-clang-tidy.py -p build/standalone standalone
	# TODO builddriver run-clang-tidy.py -p build/standalone -checks='-*,modernize-*,misc-*,hicpp-*,cert-*,readability-*,portability-*,performance-*,google-*' standalone
