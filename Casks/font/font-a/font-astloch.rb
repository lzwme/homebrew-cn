cask "font-astloch" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflastloch"
  name "Astloch"
  homepage "https:fonts.google.comspecimenAstloch"

  font "Astloch-Bold.ttf"
  font "Astloch-Regular.ttf"

  # No zap stanza required
end