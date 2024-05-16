cask "font-crimson-text" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcrimsontext"
  name "Crimson Text"
  homepage "https:fonts.google.comspecimenCrimson+Text"

  font "CrimsonText-Bold.ttf"
  font "CrimsonText-BoldItalic.ttf"
  font "CrimsonText-Italic.ttf"
  font "CrimsonText-Regular.ttf"
  font "CrimsonText-SemiBold.ttf"
  font "CrimsonText-SemiBoldItalic.ttf"

  # No zap stanza required
end