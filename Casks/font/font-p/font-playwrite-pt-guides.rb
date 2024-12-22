cask "font-playwrite-pt-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteptguidesPlaywritePTGuides-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite PT Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+PT+Guides"

  font "PlaywritePTGuides-Regular.ttf"

  # No zap stanza required
end