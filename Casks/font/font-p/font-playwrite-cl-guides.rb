cask "font-playwrite-cl-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteclguidesPlaywriteCLGuides-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite CL Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+CL+Guides"

  font "PlaywriteCLGuides-Regular.ttf"

  # No zap stanza required
end