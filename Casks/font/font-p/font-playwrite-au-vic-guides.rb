cask "font-playwrite-au-vic-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteauvicguidesPlaywriteAUVICGuides-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite AU VIC Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+AU+VIC+Guides"

  font "PlaywriteAUVICGuides-Regular.ttf"

  # No zap stanza required
end