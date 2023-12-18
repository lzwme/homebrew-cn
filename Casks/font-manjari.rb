cask "font-manjari" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflmanjari"
  name "Manjari"
  homepage "https:fonts.google.comspecimenManjari"

  font "Manjari-Bold.ttf"
  font "Manjari-Regular.ttf"
  font "Manjari-Thin.ttf"

  # No zap stanza required
end