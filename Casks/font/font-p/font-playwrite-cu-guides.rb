cask "font-playwrite-cu-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritecuguidesPlaywriteCUGuides-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite CU Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+CU+Guides"

  font "PlaywriteCUGuides-Regular.ttf"

  # No zap stanza required
end