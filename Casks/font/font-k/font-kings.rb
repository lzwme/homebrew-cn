cask "font-kings" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflkingsKings-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Kings"
  homepage "https:fonts.google.comspecimenKings"

  font "Kings-Regular.ttf"

  # No zap stanza required
end