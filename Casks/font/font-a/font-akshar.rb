cask "font-akshar" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflaksharAkshar%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Akshar"
  homepage "https:fonts.google.comspecimenAkshar"

  font "Akshar[wght].ttf"

  # No zap stanza required
end