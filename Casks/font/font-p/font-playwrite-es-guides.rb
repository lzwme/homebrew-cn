cask "font-playwrite-es-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteesguidesPlaywriteESGuides-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite ES Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+ES+Guides"

  font "PlaywriteESGuides-Regular.ttf"

  # No zap stanza required
end