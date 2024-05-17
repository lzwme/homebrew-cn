cask "font-nunito" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflnunito"
  name "Nunito"
  homepage "https:fonts.google.comspecimenNunito"

  font "Nunito-Italic[wght].ttf"
  font "Nunito[wght].ttf"

  # No zap stanza required
end