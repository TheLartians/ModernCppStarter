#include <doctest/doctest.h>
#include <greeter.h>

TEST_CASE("Greeter") {
  using namespace greeter;

  Greeter greeter("Tests");

  CHECK(greeter.greet(LanguageCode::EN) == "Hello, Tests!");
  CHECK(greeter.greet(LanguageCode::DE) == "Hallo Tests!");
  CHECK(greeter.greet(LanguageCode::ES) == "¡Hola Tests!");
  CHECK(greeter.greet(LanguageCode::FR) == "Bonjour Tests!");
}
