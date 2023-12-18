cask "font-sofia-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsofiasans"
  name "Sofia Sans"
  homepage "https:fonts.google.comspecimenSofia+Sans"

  font "SofiaSans-Italic[wght].ttf"
  font "SofiaSans[wght].ttf"

  # No zap stanza required
end