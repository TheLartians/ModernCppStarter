#include <fmt/chrono.h>
#include <greeter/greeter.h>

using namespace greeter;

Greeter::Greeter(std::string _name) : name(std::move(_name)) {}

std::string Greeter::greet(LanguageCode lang) const {
  switch (lang) {
    default:
    case LanguageCode::EN:
      return "Hello, " + name + "!";
    case LanguageCode::DE:
      return "Hallo " + name + "!";
    case LanguageCode::ES:
      return "¡Hola " + name + "!";
    case LanguageCode::FR:
      return "Bonjour " + name + "!";
  }
}

std::string Greeter::getIsoDate() const {
  using namespace std::literals::chrono_literals;
  return fmt::format("{:%H:%M:%S}", 3h + 15min + 30s);
}
