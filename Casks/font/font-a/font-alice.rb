cask "font-alice" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflaliceAlice-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Alice"
  homepage "https:fonts.google.comspecimenAlice"

  font "Alice-Regular.ttf"

  # No zap stanza required
end