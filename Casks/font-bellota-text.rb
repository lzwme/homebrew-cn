cask "font-bellota-text" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbellotatext"
  name "Bellota Text"
  homepage "https:fonts.google.comspecimenBellota+Text"

  font "BellotaText-Bold.ttf"
  font "BellotaText-BoldItalic.ttf"
  font "BellotaText-Italic.ttf"
  font "BellotaText-Light.ttf"
  font "BellotaText-LightItalic.ttf"
  font "BellotaText-Regular.ttf"

  # No zap stanza required
end