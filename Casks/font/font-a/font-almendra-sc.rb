cask "font-almendra-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflalmendrascAlmendraSC-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Almendra SC"
  homepage "https:fonts.google.comspecimenAlmendra+SC"

  font "AlmendraSC-Regular.ttf"

  # No zap stanza required
end