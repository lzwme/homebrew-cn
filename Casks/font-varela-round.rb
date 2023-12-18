cask "font-varela-round" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflvarelaroundVarelaRound-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Varela Round"
  homepage "https:fonts.google.comspecimenVarela+Round"

  font "VarelaRound-Regular.ttf"

  # No zap stanza required
end