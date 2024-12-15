cask "font-playwrite-hr-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritehrguidesPlaywriteHRGuides-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite HR Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+HR+Guides"

  font "PlaywriteHRGuides-Regular.ttf"

  # No zap stanza required
end