cask "font-bevan" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbevan"
  name "Bevan"
  homepage "https:fonts.google.comspecimenBevan"

  font "Bevan-Italic.ttf"
  font "Bevan-Regular.ttf"

  # No zap stanza required
end