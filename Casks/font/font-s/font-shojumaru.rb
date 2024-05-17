cask "font-shojumaru" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflshojumaruShojumaru-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Shojumaru"
  homepage "https:fonts.google.comspecimenShojumaru"

  font "Shojumaru-Regular.ttf"

  # No zap stanza required
end