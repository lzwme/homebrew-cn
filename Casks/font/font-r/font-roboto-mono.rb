cask "font-roboto-mono" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "apacherobotomono"
  name "Roboto Mono"
  homepage "https:fonts.google.comspecimenRoboto+Mono"

  font "RobotoMono-Italic[wght].ttf"
  font "RobotoMono[wght].ttf"

  # No zap stanza required
end