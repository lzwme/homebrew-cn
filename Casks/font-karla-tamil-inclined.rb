cask "font-karla-tamil-inclined" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflkarlatamilinclined"
  name "Karla Tamil Inclined"
  homepage "https:fonts.google.comspecimenKarla"

  font "KarlaTamilInclined-Bold.ttf"
  font "KarlaTamilInclined-Regular.ttf"

  # No zap stanza required
end