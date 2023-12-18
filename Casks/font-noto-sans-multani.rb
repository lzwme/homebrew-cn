cask "font-noto-sans-multani" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansmultaniNotoSansMultani-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Multani"
  homepage "https:fonts.google.comspecimenNoto+Sans+Multani"

  font "NotoSansMultani-Regular.ttf"

  # No zap stanza required
end