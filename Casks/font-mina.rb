cask "font-mina" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflmina"
  name "Mina"
  homepage "https:fonts.google.comspecimenMina"

  font "Mina-Bold.ttf"
  font "Mina-Regular.ttf"

  # No zap stanza required
end