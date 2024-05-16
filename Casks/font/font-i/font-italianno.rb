cask "font-italianno" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflitaliannoItalianno-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Italianno"
  homepage "https:fonts.google.comspecimenItalianno"

  font "Italianno-Regular.ttf"

  # No zap stanza required
end