cask "font-playwrite-id-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteidguidesPlaywriteIDGuides-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite ID Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+ID+Guides"

  font "PlaywriteIDGuides-Regular.ttf"

  # No zap stanza required
end