cask "font-murecho" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmurechoMurecho%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Murecho"
  homepage "https:fonts.google.comspecimenMurecho"

  font "Murecho[wght].ttf"

  # No zap stanza required
end