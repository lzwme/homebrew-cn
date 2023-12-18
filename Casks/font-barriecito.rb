cask "font-barriecito" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbarriecitoBarriecito-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Barriecito"
  homepage "https:fonts.google.comspecimenBarriecito"

  font "Barriecito-Regular.ttf"

  # No zap stanza required
end