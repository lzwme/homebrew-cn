cask "font-dm-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofldmsans"
  name "DM Sans"
  homepage "https:fonts.google.comspecimenDM+Sans"

  font "DMSans-Italic[opsz,wght].ttf"
  font "DMSans[opsz,wght].ttf"

  # No zap stanza required
end