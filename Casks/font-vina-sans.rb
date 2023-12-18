cask "font-vina-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflvinasansVinaSans-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Vina Sans"
  homepage "https:fonts.google.comspecimenVina+Sans"

  font "VinaSans-Regular.ttf"

  # No zap stanza required
end