cask "font-judson" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofljudson"
  name "Judson"
  homepage "https:fonts.google.comspecimenJudson"

  font "Judson-Bold.ttf"
  font "Judson-Italic.ttf"
  font "Judson-Regular.ttf"

  # No zap stanza required
end