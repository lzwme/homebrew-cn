cask "font-playwrite-cz" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteczPlaywriteCZ%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite CZ"
  homepage "https:fonts.google.comspecimenPlaywrite+CZ"

  font "PlaywriteCZ[wght].ttf"

  # No zap stanza required
end