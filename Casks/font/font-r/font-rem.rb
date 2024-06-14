cask "font-rem" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflrem"
  name "REM"
  homepage "https:fonts.google.comspecimenREM"

  font "REM-Italic[wght].ttf"
  font "REM[wght].ttf"

  # No zap stanza required
end