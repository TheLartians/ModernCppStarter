#

#XXX GENERATOR?="Unix Makefiles"
GENERATOR?=Ninja

STAGEDIR?="${CURDIR}/stage"
CMAKE_PRESET:=-G "${GENERATOR}" -DCMAKE_CXX_COMPILER_LAUNCHER=ccache -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_BUILD_TYPE=Debug -DCMAKE_PREFIX_PATH=${STAGEDIR}


#XXX export CXX=clang++
export CPM_USE_LOCAL_PACKAGES=0
export CPM_SOURCE_CACHE=${HOME}/.cache/CPM

.PHONY: update format all test standalone doc check clean distclean lock

# the default target does just all, but neither standalone nor doc
test:

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
	cmake -S . -B build/$@ ${CMAKE_PRESET} -DCMAKE_INSTALL_PREFIX=${STAGEDIR} -DCMAKE_CXX_STANDARD=20 #NO! -DCMAKE_CXX_CLANG_TIDY=clang-tidy # --trace-expand
	cmake --build build/$@ --target $@
	perl -i.bak -pe 's#-I($$CPM_SOURCE_CACHE)#-isystem $$1#g' build/install/compile_commands.json
	run-clang-tidy.py -p build/$@ source

# test the library
test: install
	cmake -S $@ -B build/$@ ${CMAKE_PRESET} -DTEST_INSTALLED_VERSION=1
	cmake --build build/$@
	cmake --build build/$@ --target $@

# all together
all: #XXX test
	cmake -S $@ -B build/$@ ${CMAKE_PRESET} -DENABLE_TEST_COVERAGE=1 -DUSE_STATIC_ANALYZER=clang-tidy
	cmake --build build/$@
	cmake --build build/$@ --target test
	#XXX cmake --build build/$@ --target check-format

# GenerateDocs
doc:
	cmake -S documentation -B build/documentation "${CMAKE_PRESET}"
	cmake --build build/documentation --target GenerateDocs

format: distclean
	find . -name CMakeLists.txt | xargs cmake-format -i
	find . -name '*.cmake' | xargs cmake-format -i
	find . -name '*.cpp' | xargs clang-format -i
	find . -name '*.h' | xargs clang-format -i

standalone:
	cmake -S $@ -B build/$@ ${CMAKE_PRESET}
	cmake --build build/$@

# check the library
check: standalone
	builddriver run-clang-tidy.py -p build/standalone -checks='-*,modernize-*,misc-*,hicpp-*,cert-*,readability-*,portability-*,performance-*,google-*' standalone
