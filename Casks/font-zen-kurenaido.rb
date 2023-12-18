cask "font-zen-kurenaido" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflzenkurenaidoZenKurenaido-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Zen Kurenaido"
  desc "Japanese font with a handwritten feeling"
  homepage "https:fonts.google.comspecimenZen+Kurenaido"

  font "ZenKurenaido-Regular.ttf"

  # No zap stanza required
end