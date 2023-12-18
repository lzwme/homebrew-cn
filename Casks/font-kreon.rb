cask "font-kreon" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflkreonKreon%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Kreon"
  homepage "https:fonts.google.comspecimenKreon"

  font "Kreon[wght].ttf"

  # No zap stanza required
end