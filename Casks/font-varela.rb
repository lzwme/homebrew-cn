cask "font-varela" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflvarelaVarela-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Varela"
  homepage "https:fonts.google.comspecimenVarela"

  font "Varela-Regular.ttf"

  # No zap stanza required
end