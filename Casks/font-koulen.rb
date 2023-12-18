cask "font-koulen" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflkoulenKoulen-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Koulen"
  homepage "https:fonts.google.comspecimenKoulen"

  font "Koulen-Regular.ttf"

  # No zap stanza required
end