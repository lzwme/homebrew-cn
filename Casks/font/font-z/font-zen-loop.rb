cask "font-zen-loop" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflzenloop"
  name "Zen Loop"
  homepage "https:fonts.google.comspecimenZen+Loop"

  font "ZenLoop-Italic.ttf"
  font "ZenLoop-Regular.ttf"

  # No zap stanza required
end