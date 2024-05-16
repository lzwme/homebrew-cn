cask "font-kalnia" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflkalniaKalnia%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Kalnia"
  homepage "https:fonts.google.comspecimenKalnia"

  font "Kalnia[wdth,wght].ttf"

  # No zap stanza required
end