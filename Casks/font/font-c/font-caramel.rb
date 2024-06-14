cask "font-caramel" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcaramelCaramel-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Caramel"
  homepage "https:fonts.google.comspecimenCaramel"

  font "Caramel-Regular.ttf"

  # No zap stanza required
end