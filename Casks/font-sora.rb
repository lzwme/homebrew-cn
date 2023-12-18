cask "font-sora" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsoraSora%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Sora"
  homepage "https:fonts.google.comspecimenSora"

  font "Sora[wght].ttf"

  # No zap stanza required
end