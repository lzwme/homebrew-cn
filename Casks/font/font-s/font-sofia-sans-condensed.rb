cask "font-sofia-sans-condensed" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsofiasanscondensed"
  name "Sofia Sans Condensed"
  homepage "https:fonts.google.comspecimenSofia+Sans+Condensed"

  font "SofiaSansCondensed-Italic[wght].ttf"
  font "SofiaSansCondensed[wght].ttf"

  # No zap stanza required
end