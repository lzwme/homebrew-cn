cask "font-moul" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmoulMoul-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Moul"
  homepage "https:fonts.google.comspecimenMoul"

  font "Moul-Regular.ttf"

  # No zap stanza required
end