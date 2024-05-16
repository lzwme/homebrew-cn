cask "font-caramel" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcaramelCaramel-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Caramel"
  desc "Fun, hand lettered script with three variations"
  homepage "https:fonts.google.comspecimenCaramel"

  font "Caramel-Regular.ttf"

  # No zap stanza required
end