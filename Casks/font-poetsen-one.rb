cask "font-poetsen-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpoetsenonePoetsenOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Poetsen One"
  homepage "https:fonts.google.comspecimenPoetsen+One"

  font "PoetsenOne-Regular.ttf"

  # No zap stanza required
end