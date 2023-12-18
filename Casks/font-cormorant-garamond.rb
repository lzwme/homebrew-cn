cask "font-cormorant-garamond" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcormorantgaramond"
  name "Cormorant Garamond"
  homepage "https:fonts.google.comspecimenCormorant+Garamond"

  font "CormorantGaramond-Bold.ttf"
  font "CormorantGaramond-BoldItalic.ttf"
  font "CormorantGaramond-Italic.ttf"
  font "CormorantGaramond-Light.ttf"
  font "CormorantGaramond-LightItalic.ttf"
  font "CormorantGaramond-Medium.ttf"
  font "CormorantGaramond-MediumItalic.ttf"
  font "CormorantGaramond-Regular.ttf"
  font "CormorantGaramond-SemiBold.ttf"
  font "CormorantGaramond-SemiBoldItalic.ttf"

  # No zap stanza required
end