cask "font-playwrite-pl-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteplguidesPlaywritePLGuides-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite PL Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+PL+Guides"

  font "PlaywritePLGuides-Regular.ttf"

  # No zap stanza required
end