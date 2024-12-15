cask "font-playwrite-ar-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritearguidesPlaywriteARGuides-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite AR Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+AR+Guides"

  font "PlaywriteARGuides-Regular.ttf"

  # No zap stanza required
end