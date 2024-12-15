cask "font-playwrite-ie-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteieguidesPlaywriteIEGuides-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite IE Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+IE+Guides"

  font "PlaywriteIEGuides-Regular.ttf"

  # No zap stanza required
end