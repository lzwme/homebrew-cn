cask "font-monomaniac-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmonomaniaconeMonomaniacOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Monomaniac One"
  homepage "https:fonts.google.comspecimenMonomaniac+One"

  font "MonomaniacOne-Regular.ttf"

  # No zap stanza required
end