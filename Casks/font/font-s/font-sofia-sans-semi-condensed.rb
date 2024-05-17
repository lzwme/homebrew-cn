cask "font-sofia-sans-semi-condensed" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsofiasanssemicondensed"
  name "Sofia Sans Semi Condensed"
  homepage "https:fonts.google.comspecimenSofia+Sans+Semi+Condensed"

  font "SofiaSansSemiCondensed-Italic[wght].ttf"
  font "SofiaSansSemiCondensed[wght].ttf"

  # No zap stanza required
end