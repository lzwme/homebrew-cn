cask "font-playball" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplayballPlayball-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playball"
  homepage "https:fonts.google.comspecimenPlayball"

  font "Playball-Regular.ttf"

  # No zap stanza required
end