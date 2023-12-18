cask "font-chela-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflchelaoneChelaOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Chela One"
  homepage "https:fonts.google.comspecimenChela+One"

  font "ChelaOne-Regular.ttf"

  # No zap stanza required
end