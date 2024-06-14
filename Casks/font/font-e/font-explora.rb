cask "font-explora" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflexploraExplora-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Explora"
  homepage "https:fonts.google.comspecimenExplora"

  font "Explora-Regular.ttf"

  # No zap stanza required
end