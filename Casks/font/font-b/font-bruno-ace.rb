cask "font-bruno-ace" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbrunoaceBrunoAce-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bruno Ace"
  homepage "https:fonts.google.comspecimenBruno+Ace"

  font "BrunoAce-Regular.ttf"

  # No zap stanza required
end