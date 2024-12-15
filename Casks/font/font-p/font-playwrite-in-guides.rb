cask "font-playwrite-in-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteinguidesPlaywriteINGuides-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite IN Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+IN+Guides"

  font "PlaywriteINGuides-Regular.ttf"

  # No zap stanza required
end