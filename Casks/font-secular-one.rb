cask "font-secular-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsecularoneSecularOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Secular One"
  homepage "https:fonts.google.comspecimenSecular+One"

  font "SecularOne-Regular.ttf"

  # No zap stanza required
end