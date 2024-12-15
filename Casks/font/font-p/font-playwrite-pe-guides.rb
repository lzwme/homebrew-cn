cask "font-playwrite-pe-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritepeguidesPlaywritePEGuides-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite PE Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+PE+Guides"

  font "PlaywritePEGuides-Regular.ttf"

  # No zap stanza required
end