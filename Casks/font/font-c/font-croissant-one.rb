cask "font-croissant-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcroissantoneCroissantOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Croissant One"
  homepage "https:fonts.google.comspecimenCroissant+One"

  font "CroissantOne-Regular.ttf"

  # No zap stanza required
end