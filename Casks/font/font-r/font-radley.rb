cask "font-radley" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflradley"
  name "Radley"
  homepage "https:fonts.google.comspecimenRadley"

  font "Radley-Italic.ttf"
  font "Radley-Regular.ttf"

  # No zap stanza required
end