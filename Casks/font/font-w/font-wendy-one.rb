cask "font-wendy-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflwendyoneWendyOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Wendy One"
  homepage "https:fonts.google.comspecimenWendy+One"

  font "WendyOne-Regular.ttf"

  # No zap stanza required
end