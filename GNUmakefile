#
# CURDIR=$(/bin/pwd)
# On UNIX one can use the DESTDIR mechanism in order to relocate the whole installation.
DESTDIR?=${CURDIR}/stagedir
export DESTDIR

# GENERATOR?="Unix Makefiles"
GENERATOR?=Ninja

export CPM_SOURCE_CACHE=${HOME}/.cache/CPM
export CPM_USE_LOCAL_PACKAGES=1

.PHONY: update format all test standalone check clean distclean lock

# the default target does just all
all:

clean:
	find . -type d -name build | xargs rm -rf

distclean: clean
	rm -rf build ${DESTDIR}

# update CPM.cmake
update:
	wget -q -O cmake/CPM.cmake https://github.com/cpm-cmake/CPM.cmake/releases/latest/download/get_cpm.cmake

lock: standalone all
	cmake --build build/all --target cpm-update-package-lock
	cmake --build build/test --target cpm-update-package-lock
	cmake --build build/install --target cpm-update-package-lock
	cmake --build build/standalone --target cpm-update-package-lock

# install the library
install:
	cmake -S . -B build/install -G "${GENERATOR}" -DCMAKE_PREFIX_PATH=${DESTDIR} # --trace-expand
	cmake --build build/install --target install

# test the library
test: install
	cmake -S test -B build/test -G "${GENERATOR}" -DCMAKE_PREFIX_PATH=${DESTDIR} -DTEST_INSTALLED_VERSION=1
	cmake --build build/test
	cmake --build build/test --target test

# all together
all: test
	cmake -S all -B build/all -G "${GENERATOR}" -DCMAKE_PREFIX_PATH=${DESTDIR} -DTEST_INSTALLED_VERSION=1 -DENABLE_TEST_COVERAGE=1
	cmake --build build/all
	cmake --build build/all --target test
	cmake --build build/all --target GenerateDocs
	cmake --build build/all --target check-format

format: distclean
	find . -name CMakeLists.txt | xargs cmake-format -i
	find . -name '*.cmake' | xargs cmake-format -i
	find . -name '*.cpp' | xargs clang-format -i
	find . -name '*.h' | xargs clang-format -i

standalone:
	cmake -S standalone -B build/standalone -G "${GENERATOR}" -DCMAKE_PREFIX_PATH=${DESTDIR} -DCMAKE_EXPORT_COMPILE_COMMANDS=1
	cmake --build build/standalone --target all

# check the library
check: standalone
	run-clang-tidy.py -p build/standalone -checks='-*,modernize-*,misc-*,hicpp-*,cert-*,readability-*,portability-*,performance-*,google-*' standalone
