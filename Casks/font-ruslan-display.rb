cask "font-ruslan-display" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflruslandisplayRuslanDisplay-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Ruslan Display"
  homepage "https:fonts.google.comspecimenRuslan+Display"

  font "RuslanDisplay-Regular.ttf"

  # No zap stanza required
end