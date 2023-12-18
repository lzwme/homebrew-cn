cask "font-volkhov" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflvolkhov"
  name "Volkhov"
  homepage "https:fonts.google.comspecimenVolkhov"

  font "Volkhov-Bold.ttf"
  font "Volkhov-BoldItalic.ttf"
  font "Volkhov-Italic.ttf"
  font "Volkhov-Regular.ttf"

  # No zap stanza required
end