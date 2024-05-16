cask "font-golos-text" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgolostextGolosText%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Golos Text"
  homepage "https:fonts.google.comspecimenGolos+Text"

  font "GolosText[wght].ttf"

  # No zap stanza required
end