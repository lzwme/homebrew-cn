cask "font-playwrite-ca-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritecaguidesPlaywriteCAGuides-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite CA Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+CA+Guides"

  font "PlaywriteCAGuides-Regular.ttf"

  # No zap stanza required
end