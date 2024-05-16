cask "font-codystar" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcodystar"
  name "Codystar"
  homepage "https:fonts.google.comspecimenCodystar"

  font "Codystar-Light.ttf"
  font "Codystar-Regular.ttf"

  # No zap stanza required
end