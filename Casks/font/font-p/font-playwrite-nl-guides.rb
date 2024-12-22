cask "font-playwrite-nl-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritenlguidesPlaywriteNLGuides-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite NL Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+NL+Guides"

  font "PlaywriteNLGuides-Regular.ttf"

  # No zap stanza required
end