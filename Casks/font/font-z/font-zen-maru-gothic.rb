cask "font-zen-maru-gothic" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflzenmarugothic"
  name "Zen Maru Gothic"
  desc "Also easy to use in any scenes"
  homepage "https:fonts.google.comspecimenZen+Maru+Gothic"

  font "ZenMaruGothic-Black.ttf"
  font "ZenMaruGothic-Bold.ttf"
  font "ZenMaruGothic-Light.ttf"
  font "ZenMaruGothic-Medium.ttf"
  font "ZenMaruGothic-Regular.ttf"

  # No zap stanza required
end