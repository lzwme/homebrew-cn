cask "font-chango" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflchangoChango-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Chango"
  homepage "https:fonts.google.comspecimenChango"

  font "Chango-Regular.ttf"

  # No zap stanza required
end