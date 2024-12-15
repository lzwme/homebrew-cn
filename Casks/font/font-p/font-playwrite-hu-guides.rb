cask "font-playwrite-hu-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritehuguidesPlaywriteHUGuides-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite HU Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+HU+Guides"

  font "PlaywriteHUGuides-Regular.ttf"

  # No zap stanza required
end