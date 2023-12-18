cask "font-agdasima" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflagdasima"
  name "Agdasima"
  desc "Based on big shoulders, a condensed american gothic sans-serif font family"
  homepage "https:fonts.google.comspecimenAgdasima"

  font "Agdasima-Bold.ttf"
  font "Agdasima-Regular.ttf"

  # No zap stanza required
end