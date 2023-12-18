cask "font-noto-sans-marchen" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansmarchenNotoSansMarchen-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Marchen"
  homepage "https:fonts.google.comspecimenNoto+Sans+Marchen"

  font "NotoSansMarchen-Regular.ttf"

  # No zap stanza required
end