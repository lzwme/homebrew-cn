cask "font-tuffy" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofltuffy"
  name "Tuffy"
  homepage "http:tulrich.comfonts"

  font "Tuffy-Bold.ttf"
  font "Tuffy-BoldItalic.ttf"
  font "Tuffy-Italic.ttf"
  font "Tuffy-Regular.ttf"

  # No zap stanza required
end