cask "font-amaranth" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflamaranth"
  name "Amaranth"
  homepage "https:fonts.google.comspecimenAmaranth"

  font "Amaranth-Bold.ttf"
  font "Amaranth-BoldItalic.ttf"
  font "Amaranth-Italic.ttf"
  font "Amaranth-Regular.ttf"

  # No zap stanza required
end