cask "font-nobile" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflnobile"
  name "Nobile"
  homepage "https:fonts.google.comspecimenNobile"

  font "Nobile-Bold.ttf"
  font "Nobile-BoldItalic.ttf"
  font "Nobile-Italic.ttf"
  font "Nobile-Medium.ttf"
  font "Nobile-MediumItalic.ttf"
  font "Nobile-Regular.ttf"

  # No zap stanza required
end