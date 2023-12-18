cask "font-kite-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflkiteoneKiteOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Kite One"
  homepage "https:fonts.google.comspecimenKite+One"

  font "KiteOne-Regular.ttf"

  # No zap stanza required
end