#
# CURDIR=$(/bin/pwd)
#
# GENERATOR="Unix Makefiles"
GENERATOR=Ninja

export CPM_SOURCE_CACHE=${HOME}/.cache/CPM
export CPM_USE_LOCAL_PACKAGES=1

.PHONY: update format all test check clean distclean lock

# the default target does just all
check: all

all: test

test: install


distclean:
	rm -rf build root

# update CPM.cmake
update:
	wget -q -O cmake/CPM.cmake https://github.com/cpm-cmake/CPM.cmake/releases/latest/download/get_cpm.cmake

lock: install
	cmake --build build/install --target cpm-update-package-lock

# install the library
install:
	cmake -S . -B build/install -G "${GENERATOR}" -DCMAKE_PREFIX_PATH=${CURDIR}/root -DCMAKE_INSTALL_PREFIX=${CURDIR}/root -DCMAKE_CXX_STANDARD=20 # --trace-expand
	cmake --build build/install --target install

# test the library
test:
	cmake -S test -B build/test -G "${GENERATOR}" -DCMAKE_PREFIX_PATH=${CURDIR}/root -DTEST_INSTALLED_VERSION=1
	cmake --build build/test
	cmake --build build/test --target test

# all together
all:
	cmake -S all -B build/all -G "${GENERATOR}" -DCMAKE_PREFIX_PATH=${CURDIR}/root -DTEST_INSTALLED_VERSION=1 -DENABLE_TEST_COVERAGE=1
	cmake --build build/all
	cmake --build build/all --target test
	cmake --build build/all --target GenerateDocs
	cmake --build build/all --target check-format

format: distclean
	find . -name CMakeLists.txt | xargs cmake-format -i
	find . -name '*.cpp' | xargs clang-format -i
	find . -name '*.h' | xargs clang-format -i

# check the library
check:
	cmake -S standalone -B build/standalone -G "${GENERATOR}" -DCMAKE_PREFIX_PATH=${CURDIR}/root -DCMAKE_EXPORT_COMPILE_COMMANDS=1
	cmake --build build/standalone --target all
	run-clang-tidy.py -p build/standalone -checks='-*,modernize-*,misc-*,hicpp-*,cert-*,readability-*,portability-*,performance-*,google-*' standalone
