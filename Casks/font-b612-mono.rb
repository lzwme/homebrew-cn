cask "font-b612-mono" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflb612mono"
  name "B612 Mono"
  homepage "https:fonts.google.comspecimenB612+Mono"

  font "B612Mono-Bold.ttf"
  font "B612Mono-BoldItalic.ttf"
  font "B612Mono-Italic.ttf"
  font "B612Mono-Regular.ttf"

  # No zap stanza required
end