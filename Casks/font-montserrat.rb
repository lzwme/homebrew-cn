cask "font-montserrat" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflmontserrat"
  name "Montserrat"
  homepage "https:fonts.google.comspecimenMontserrat"

  font "Montserrat-Italic[wght].ttf"
  font "Montserrat[wght].ttf"

  # No zap stanza required
end