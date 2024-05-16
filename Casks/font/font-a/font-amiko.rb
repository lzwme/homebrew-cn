cask "font-amiko" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflamiko"
  name "Amiko"
  homepage "https:fonts.google.comspecimenAmiko"

  font "Amiko-Bold.ttf"
  font "Amiko-Regular.ttf"
  font "Amiko-SemiBold.ttf"

  # No zap stanza required
end