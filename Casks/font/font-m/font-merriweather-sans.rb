cask "font-merriweather-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflmerriweathersans"
  name "Merriweather Sans"
  homepage "https:fonts.google.comspecimenMerriweather+Sans"

  font "MerriweatherSans-Italic[wght].ttf"
  font "MerriweatherSans[wght].ttf"

  # No zap stanza required
end