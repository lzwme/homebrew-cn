cask "font-poltawski-nowy" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflpoltawskinowy"
  name "Poltawski Nowy"
  homepage "https:fonts.google.comspecimenPoltawski+Nowy"

  font "PoltawskiNowy-Italic[wght].ttf"
  font "PoltawskiNowy[wght].ttf"

  # No zap stanza required
end