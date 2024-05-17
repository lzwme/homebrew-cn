cask "font-quicksand" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflquicksandQuicksand%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Quicksand"
  homepage "https:fonts.google.comspecimenQuicksand"

  font "Quicksand[wght].ttf"

  # No zap stanza required
end