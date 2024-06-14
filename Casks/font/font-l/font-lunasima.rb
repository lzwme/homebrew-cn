cask "font-lunasima" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofllunasima"
  name "Lunasima"
  homepage "https:fonts.google.comspecimenLunasima"

  font "Lunasima-Bold.ttf"
  font "Lunasima-Regular.ttf"

  # No zap stanza required
end