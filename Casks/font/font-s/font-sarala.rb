cask "font-sarala" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsarala"
  name "Sarala"
  homepage "https:fonts.google.comspecimenSarala"

  font "Sarala-Bold.ttf"
  font "Sarala-Regular.ttf"

  # No zap stanza required
end