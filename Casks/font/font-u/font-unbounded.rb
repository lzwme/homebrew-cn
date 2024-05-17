cask "font-unbounded" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflunboundedUnbounded%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Unbounded"
  desc "Possibly the first on-chain funded font in the world"
  homepage "https:fonts.google.comspecimenUnbounded"

  font "Unbounded[wght].ttf"

  # No zap stanza required
end