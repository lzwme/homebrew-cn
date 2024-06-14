cask "font-licorice" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllicoriceLicorice-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Licorice"
  homepage "https:fonts.google.comspecimenLicorice"

  font "Licorice-Regular.ttf"

  # No zap stanza required
end