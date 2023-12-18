cask "font-nunito-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflnunitosans"
  name "Nunito Sans"
  homepage "https:fonts.google.comspecimenNunito+Sans"

  font "NunitoSans-Italic[YTLC,opsz,wdth,wght].ttf"
  font "NunitoSans[YTLC,opsz,wdth,wght].ttf"

  # No zap stanza required
end