cask "font-stalemate" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflstalemateStalemate-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Stalemate"
  homepage "https:fonts.google.comspecimenStalemate"

  font "Stalemate-Regular.ttf"

  # No zap stanza required
end