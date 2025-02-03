cask "font-merriweather" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflmerriweather"
  name "Merriweather"
  homepage "https:fonts.google.comspecimenMerriweather"

  font "Merriweather-Italic[opsz,wdth,wght].ttf"
  font "Merriweather[opsz,wdth,wght].ttf"

  # No zap stanza required
end