#include <greeter.h>

using namespace greeter;

Greeter::Greeter(std::string _name) : name(_name) {}

std::string Greeter::greet(LanguageCode lang) const {
  switch (lang) {
#if defined(_WIN32) || defined(WIN32)
    // this silences a MSVC warning as it does not seem to understand strongly-typed enums
    default:
#endif
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
