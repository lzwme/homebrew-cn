cask "font-playwrite-cu" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritecuPlaywriteCU%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite CU"
  homepage "https:fonts.google.comspecimenPlaywrite+CU"

  font "PlaywriteCU[wght].ttf"

  # No zap stanza required
end