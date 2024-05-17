cask "font-thabit" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflthabit"
  name "Thabit"
  homepage "https:fonts.google.comearlyaccess"

  font "Thabit-Bold.ttf"
  font "Thabit-BoldOblique.ttf"
  font "Thabit-Oblique.ttf"
  font "Thabit.ttf"

  # No zap stanza required
end