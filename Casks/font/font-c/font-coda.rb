cask "font-coda" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcoda"
  name "Coda"
  homepage "https:fonts.google.comspecimenCoda"

  font "Coda-ExtraBold.ttf"
  font "Coda-Regular.ttf"

  # No zap stanza required
end