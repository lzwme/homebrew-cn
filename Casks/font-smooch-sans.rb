cask "font-smooch-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsmoochsansSmoochSans%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Smooch Sans"
  homepage "https:fonts.google.comspecimenSmooch+Sans"

  font "SmoochSans[wght].ttf"

  # No zap stanza required
end