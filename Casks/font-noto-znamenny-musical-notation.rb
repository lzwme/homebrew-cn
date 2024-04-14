cask "font-noto-znamenny-musical-notation" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoznamennymusicalnotationNotoZnamennyMusicalNotation-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Znamenny Musical Notation"
  homepage "https:fonts.google.comspecimenNoto+Znamenny+Musical+Notation"

  font "NotoZnamennyMusicalNotation-Regular.ttf"

  # No zap stanza required
end