cask "font-ko-pub-batang" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflkopubbatang"
  name "Ko Pub Batang"
  homepage "https:fonts.google.comearlyaccess"

  font "KoPubBatang-Bold.ttf"
  font "KoPubBatang-Light.ttf"
  font "KoPubBatang-Regular.ttf"

  # No zap stanza required
end