cask "font-azeret-mono" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflazeretmono"
  name "Azeret Mono"
  desc "Designed by martin vácha and daniel quisek"
  homepage "https:fonts.google.comspecimenAzeret+Mono"

  font "AzeretMono-Italic[wght].ttf"
  font "AzeretMono[wght].ttf"

  # No zap stanza required
end