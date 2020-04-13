#pragma once

#include <string>

namespace greeter {

  enum class LanguageCode { EN, DE, ES, FR };

  class Greeter {
    std::string name;

  public:
    Greeter(std::string name);
    std::string greet(LanguageCode lang = LanguageCode::EN) const;
  };

}  // namespace greeter
