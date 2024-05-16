cask "font-kadwa" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflkadwa"
  name "Kadwa"
  homepage "https:fonts.google.comspecimenKadwa"

  font "Kadwa-Bold.ttf"
  font "Kadwa-Regular.ttf"

  # No zap stanza required
end