cask "font-noto-sans-chorasmian" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanschorasmianNotoSansChorasmian-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Chorasmian"
  homepage "https:fonts.google.comspecimenNoto+Sans+Chorasmian"

  font "NotoSansChorasmian-Regular.ttf"

  # No zap stanza required
end