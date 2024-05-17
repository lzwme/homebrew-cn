cask "font-work-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflworksans"
  name "Work Sans"
  homepage "https:fonts.google.comspecimenWork+Sans"

  font "WorkSans-Italic[wght].ttf"
  font "WorkSans[wght].ttf"

  # No zap stanza required
end