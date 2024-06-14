cask "font-noto-sans-nandinagari" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansnandinagariNotoSansNandinagari-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Nandinagari"
  homepage "https:fonts.google.comspecimenNoto+Sans+Nandinagari"

  font "NotoSansNandinagari-Regular.ttf"

  # No zap stanza required
end