cask "font-tangerine" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofltangerine"
  name "Tangerine"
  homepage "https:fonts.google.comspecimenTangerine"

  font "Tangerine-Bold.ttf"
  font "Tangerine-Regular.ttf"

  # No zap stanza required
end