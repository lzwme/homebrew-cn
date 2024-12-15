cask "font-playwrite-br-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritebrguidesPlaywriteBRGuides-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite BR Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+BR+Guides"

  font "PlaywriteBRGuides-Regular.ttf"

  # No zap stanza required
end