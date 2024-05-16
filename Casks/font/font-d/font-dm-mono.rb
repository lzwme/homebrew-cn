cask "font-dm-mono" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofldmmono"
  name "DM Mono"
  homepage "https:fonts.google.comspecimenDM+Mono"

  font "DMMono-Italic.ttf"
  font "DMMono-Light.ttf"
  font "DMMono-LightItalic.ttf"
  font "DMMono-Medium.ttf"
  font "DMMono-MediumItalic.ttf"
  font "DMMono-Regular.ttf"

  # No zap stanza required
end