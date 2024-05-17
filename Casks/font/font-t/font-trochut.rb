cask "font-trochut" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofltrochut"
  name "Trochut"
  homepage "https:fonts.google.comspecimenTrochut"

  font "Trochut-Bold.ttf"
  font "Trochut-Italic.ttf"
  font "Trochut-Regular.ttf"

  # No zap stanza required
end