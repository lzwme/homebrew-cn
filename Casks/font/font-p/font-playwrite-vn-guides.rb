cask "font-playwrite-vn-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritevnguidesPlaywriteVNGuides-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite VN Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+VN+Guides"

  font "PlaywriteVNGuides-Regular.ttf"

  # No zap stanza required
end