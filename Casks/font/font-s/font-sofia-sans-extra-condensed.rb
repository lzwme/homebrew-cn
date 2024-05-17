cask "font-sofia-sans-extra-condensed" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsofiasansextracondensed"
  name "Sofia Sans Extra Condensed"
  homepage "https:fonts.google.comspecimenSofia+Sans+Extra+Condensed"

  font "SofiaSansExtraCondensed-Italic[wght].ttf"
  font "SofiaSansExtraCondensed[wght].ttf"

  # No zap stanza required
end