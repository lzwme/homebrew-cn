cask "font-playwrite-co-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritecoguidesPlaywriteCOGuides-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite CO Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+CO+Guides"

  font "PlaywriteCOGuides-Regular.ttf"

  # No zap stanza required
end