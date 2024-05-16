cask "font-arya" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflarya"
  name "Arya"
  homepage "https:fonts.google.comspecimenArya"

  font "Arya-Bold.ttf"
  font "Arya-Regular.ttf"

  # No zap stanza required
end