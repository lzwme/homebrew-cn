cask "font-comfortaa" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcomfortaaComfortaa%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Comfortaa"
  homepage "https:fonts.google.comspecimenComfortaa"

  font "Comfortaa[wght].ttf"

  # No zap stanza required
end