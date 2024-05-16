cask "font-imprima" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflimprimaImprima-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Imprima"
  homepage "https:fonts.google.comspecimenImprima"

  font "Imprima-Regular.ttf"

  # No zap stanza required
end