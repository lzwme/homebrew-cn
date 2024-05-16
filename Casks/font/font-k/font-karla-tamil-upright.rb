cask "font-karla-tamil-upright" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflkarlatamilupright"
  name "Karla Tamil Upright"
  homepage "https:fonts.google.comspecimenKarla"

  font "KarlaTamilUpright-Bold.ttf"
  font "KarlaTamilUpright-Regular.ttf"

  # No zap stanza required
end