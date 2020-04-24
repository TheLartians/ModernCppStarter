#include <doctest/doctest.h>
#include <greeter.h>

TEST_CASE("Greeter") {
  using namespace greeter;

  Greeter greeter("World");

  CHECK(greeter.greet(LanguageCode::EN) == "Hello, World!");
  CHECK(greeter.greet(LanguageCode::DE) == "Hallo World!");
  CHECK(greeter.greet(LanguageCode::ES) == "¡Hola World!");
  CHECK(greeter.greet(LanguageCode::FR) == "Bonjour World!");
}
