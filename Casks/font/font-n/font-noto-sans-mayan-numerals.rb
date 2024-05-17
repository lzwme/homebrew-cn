cask "font-noto-sans-mayan-numerals" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansmayannumeralsNotoSansMayanNumerals-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Mayan Numerals"
  homepage "https:fonts.google.comspecimenNoto+Sans+Mayan+Numerals"

  font "NotoSansMayanNumerals-Regular.ttf"

  # No zap stanza required
end