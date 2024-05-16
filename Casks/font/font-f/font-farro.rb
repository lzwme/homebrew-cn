cask "font-farro" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflfarro"
  name "Farro"
  homepage "https:fonts.google.comspecimenFarro"

  font "Farro-Bold.ttf"
  font "Farro-Light.ttf"
  font "Farro-Medium.ttf"
  font "Farro-Regular.ttf"

  # No zap stanza required
end