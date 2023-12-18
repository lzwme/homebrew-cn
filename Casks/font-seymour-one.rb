cask "font-seymour-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflseymouroneSeymourOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Seymour One"
  homepage "https:fonts.google.comspecimenSeymour+One"

  font "SeymourOne-Regular.ttf"

  # No zap stanza required
end