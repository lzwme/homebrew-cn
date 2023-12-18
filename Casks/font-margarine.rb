cask "font-margarine" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmargarineMargarine-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Margarine"
  homepage "https:fonts.google.comspecimenMargarine"

  font "Margarine-Regular.ttf"

  # No zap stanza required
end