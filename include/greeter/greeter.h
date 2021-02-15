#pragma once

#include <greeter/greeter_export.h>

#include <string>

namespace greeter {

  /**  Language codes to be used with the Greeter class */
  enum class GREETER_EXPORT LanguageCode { EN, DE, ES, FR };

  /**
   * @brief A class for saying hello in multiple languages
   */
  class GREETER_EXPORT Greeter {
  protected:
    std::string GREETER_EXPORT name;

  public:
    /**
     * @brief Creates a new greeter
     * @param name the name to greet
     */
    explicit Greeter(std::string _name);

    /**
     * @brief Creates a localized string containing the greeting
     * @param lang the language to greet in
     * @return a string containing the greeting
     */
    [[nodiscard]] auto greet(LanguageCode lang = LanguageCode::EN) const -> std::string;
  };

}  // namespace greeter
