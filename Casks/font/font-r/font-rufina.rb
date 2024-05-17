cask "font-rufina" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflrufina"
  name "Rufina"
  homepage "https:fonts.google.comspecimenRufina"

  font "Rufina-Bold.ttf"
  font "Rufina-Regular.ttf"

  # No zap stanza required
end