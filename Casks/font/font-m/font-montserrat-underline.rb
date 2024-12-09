cask "font-montserrat-underline" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflmontserratunderline"
  name "Montserrat Underline"
  homepage "https:fonts.google.comspecimenMontserrat+Underline"

  font "MontserratUnderline-Italic[wght].ttf"
  font "MontserratUnderline[wght].ttf"

  # No zap stanza required
end