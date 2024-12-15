cask "font-playwrite-nz-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritenzguidesPlaywriteNZGuides-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite NZ Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+NZ+Guides"

  font "PlaywriteNZGuides-Regular.ttf"

  # No zap stanza required
end