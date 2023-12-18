cask "font-ruge-boogie" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrugeboogieRugeBoogie-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Ruge Boogie"
  homepage "https:fonts.google.comspecimenRuge+Boogie"

  font "RugeBoogie-Regular.ttf"

  # No zap stanza required
end