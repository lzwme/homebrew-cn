cask "font-akatab" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflakatab"
  name "Akatab"
  homepage "https:fonts.google.comspecimenAkatab"

  font "Akatab-Black.ttf"
  font "Akatab-Bold.ttf"
  font "Akatab-ExtraBold.ttf"
  font "Akatab-Medium.ttf"
  font "Akatab-Regular.ttf"
  font "Akatab-SemiBold.ttf"

  # No zap stanza required
end