#pragma once

#include <string>

#if defined(_WIN32) || defined(WIN32)
// apparently this is required to use strings in MSVC++
#  include <sstream>
#endif

namespace greeter {

  enum class LanguageCode { EN, DE, ES, FR };

  class Greeter {
    std::string name;

  public:
    Greeter(std::string name = "World");
    std::string greet(LanguageCode lang = LanguageCode::EN) const;
  };

}  // namespace greeter
