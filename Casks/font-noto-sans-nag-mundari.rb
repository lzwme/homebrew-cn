cask "font-noto-sans-nag-mundari" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansnagmundariNotoSansNagMundari%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Nag Mundari"
  desc "Design for the indic nag mundari script"
  homepage "https:fonts.google.comspecimenNoto+Sans+Nag+Mundari"

  font "NotoSansNagMundari[wght].ttf"

  # No zap stanza required
end