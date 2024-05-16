cask "font-gayathri" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflgayathri"
  name "Gayathri"
  homepage "https:fonts.google.comspecimenGayathri"

  font "Gayathri-Bold.ttf"
  font "Gayathri-Regular.ttf"
  font "Gayathri-Thin.ttf"

  # No zap stanza required
end