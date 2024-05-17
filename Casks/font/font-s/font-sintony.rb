cask "font-sintony" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsintony"
  name "Sintony"
  homepage "https:fonts.google.comspecimenSintony"

  font "Sintony-Bold.ttf"
  font "Sintony-Regular.ttf"

  # No zap stanza required
end