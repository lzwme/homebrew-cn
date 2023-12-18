cask "font-lobster" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllobsterLobster-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Lobster"
  homepage "https:fonts.google.comspecimenLobster"

  font "Lobster-Regular.ttf"

  # No zap stanza required
end