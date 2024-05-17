cask "font-old-standard-tt" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofloldstandardtt"
  name "Old Standard TT"
  homepage "https:fonts.google.comspecimenOld+Standard+TT"

  font "OldStandard-Bold.ttf"
  font "OldStandard-Italic.ttf"
  font "OldStandard-Regular.ttf"

  # No zap stanza required
end