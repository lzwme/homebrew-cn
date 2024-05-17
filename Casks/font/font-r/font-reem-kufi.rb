cask "font-reem-kufi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflreemkufiReemKufi%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Reem Kufi"
  homepage "https:fonts.google.comspecimenReem+Kufi"

  font "ReemKufi[wght].ttf"

  # No zap stanza required
end