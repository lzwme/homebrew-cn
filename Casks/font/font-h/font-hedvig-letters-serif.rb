cask "font-hedvig-letters-serif" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflhedviglettersserifHedvigLettersSerif%5Bopsz%5D.ttf",
      verified: "github.comgooglefonts"
  name "Hedvig Letters Serif"
  desc "Perfect when it’s not"
  homepage "https:fonts.google.comspecimenHedvig+Letters+Serif"

  font "HedvigLettersSerif[opsz].ttf"

  # No zap stanza required
end