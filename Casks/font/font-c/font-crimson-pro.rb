cask "font-crimson-pro" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcrimsonpro"
  name "Crimson Pro"
  homepage "https:fonts.google.comspecimenCrimson+Pro"

  font "CrimsonPro-Italic[wght].ttf"
  font "CrimsonPro[wght].ttf"

  # No zap stanza required
end