cask "font-vibes" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflvibesVibes-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Vibes"
  homepage "https:fonts.google.comspecimenVibes"

  font "Vibes-Regular.ttf"

  # No zap stanza required
end