cask "font-charmonman" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcharmonman"
  name "Charmonman"
  homepage "https:fonts.google.comspecimenCharmonman"

  font "Charmonman-Bold.ttf"
  font "Charmonman-Regular.ttf"

  # No zap stanza required
end