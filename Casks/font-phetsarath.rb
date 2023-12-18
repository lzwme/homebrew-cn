cask "font-phetsarath" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflphetsarath"
  name "Phetsarath"
  homepage "https:fonts.google.comearlyaccess"

  font "Phetsarath-Bold.ttf"
  font "Phetsarath-Regular.ttf"

  # No zap stanza required
end