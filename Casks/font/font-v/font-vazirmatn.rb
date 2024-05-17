cask "font-vazirmatn" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflvazirmatnVazirmatn%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Vazirmatn"
  desc "Combined with roboto"
  homepage "https:fonts.google.comspecimenVazirmatn"

  font "Vazirmatn[wght].ttf"

  # No zap stanza required
end