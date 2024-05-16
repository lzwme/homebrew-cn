cask "font-amatic-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflamaticsc"
  name "Amatic SC"
  homepage "https:fonts.google.comspecimenAmatic+SC"

  font "AmaticSC-Bold.ttf"
  font "AmaticSC-Regular.ttf"

  # No zap stanza required
end