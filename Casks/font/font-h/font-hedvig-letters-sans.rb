cask "font-hedvig-letters-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflhedvigletterssansHedvigLettersSans-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Hedvig Letters Sans"
  desc "Perfect when it’s not"
  homepage "https:fonts.google.comspecimenHedvig+Letters+Sans"

  font "HedvigLettersSans-Regular.ttf"

  # No zap stanza required
end