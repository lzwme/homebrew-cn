cask "font-playwrite-tz-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritetzguidesPlaywriteTZGuides-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite TZ Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+TZ+Guides"

  font "PlaywriteTZGuides-Regular.ttf"

  # No zap stanza required
end