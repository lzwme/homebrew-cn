cask "font-playwrite-ro-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteroguidesPlaywriteROGuides-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite RO Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+RO+Guides"

  font "PlaywriteROGuides-Regular.ttf"

  # No zap stanza required
end