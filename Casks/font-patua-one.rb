cask "font-patua-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpatuaonePatuaOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Patua One"
  homepage "https:fonts.google.comspecimenPatua+One"

  font "PatuaOne-Regular.ttf"

  # No zap stanza required
end