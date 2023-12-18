cask "font-almendra-display" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflalmendradisplayAlmendraDisplay-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Almendra Display"
  homepage "https:fonts.google.comspecimenAlmendra+Display"

  font "AlmendraDisplay-Regular.ttf"

  # No zap stanza required
end