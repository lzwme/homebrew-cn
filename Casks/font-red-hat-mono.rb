cask "font-red-hat-mono" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflredhatmono"
  name "Red Hat Mono"
  homepage "https:fonts.google.comspecimenRed+Hat+Mono"

  font "RedHatMono-Italic[wght].ttf"
  font "RedHatMono[wght].ttf"

  # No zap stanza required
end