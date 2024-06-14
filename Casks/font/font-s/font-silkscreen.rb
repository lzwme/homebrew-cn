cask "font-silkscreen" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsilkscreen"
  name "Silkscreen"
  homepage "https:fonts.google.comspecimenSilkscreen"

  font "Silkscreen-Bold.ttf"
  font "Silkscreen-Regular.ttf"

  # No zap stanza required
end