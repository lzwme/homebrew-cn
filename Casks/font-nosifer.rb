cask "font-nosifer" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnosiferNosifer-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Nosifer"
  homepage "https:fonts.google.comspecimenNosifer"

  font "Nosifer-Regular.ttf"

  # No zap stanza required
end