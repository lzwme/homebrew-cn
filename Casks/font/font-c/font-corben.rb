cask "font-corben" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcorben"
  name "Corben"
  homepage "https:fonts.google.comspecimenCorben"

  font "Corben-Bold.ttf"
  font "Corben-Regular.ttf"

  # No zap stanza required
end