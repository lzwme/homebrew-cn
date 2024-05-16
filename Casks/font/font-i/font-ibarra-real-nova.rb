cask "font-ibarra-real-nova" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflibarrarealnova"
  name "Ibarra Real Nova"
  homepage "https:fonts.google.comspecimenIbarra+Real+Nova"

  font "IbarraRealNova-Italic[wght].ttf"
  font "IbarraRealNova[wght].ttf"

  # No zap stanza required
end