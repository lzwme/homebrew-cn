cask "font-noto-sans-nabataean" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansnabataeanNotoSansNabataean-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Nabataean"
  homepage "https:fonts.google.comspecimenNoto+Sans+Nabataean"

  font "NotoSansNabataean-Regular.ttf"

  # No zap stanza required
end