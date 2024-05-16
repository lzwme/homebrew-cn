cask "font-flamenco" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflflamenco"
  name "Flamenco"
  homepage "https:fonts.google.comspecimenFlamenco"

  font "Flamenco-Light.ttf"
  font "Flamenco-Regular.ttf"

  # No zap stanza required
end