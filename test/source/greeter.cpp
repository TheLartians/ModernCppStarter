#include <doctest/doctest.h>
#include <greeter.h>

#if defined(_WIN32) || defined(WIN32)
// apparently this is required to compile in MSVC++
#  include <sstream>
#endif

TEST_CASE("Greeter") {
  using namespace greeter;

  Greeter greeter("World");

  CHECK(greeter.greet(LanguageCode::EN) == "Hello, World!");
  CHECK(greeter.greet(LanguageCode::DE) == "Hallo World!");
  CHECK(greeter.greet(LanguageCode::ES) == "¡Hola World!");
  CHECK(greeter.greet(LanguageCode::FR) == "Bonjour World!");
}
