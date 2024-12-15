cask "font-playwrite-is-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteisguidesPlaywriteISGuides-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite IS Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+IS+Guides"

  font "PlaywriteISGuides-Regular.ttf"

  # No zap stanza required
end