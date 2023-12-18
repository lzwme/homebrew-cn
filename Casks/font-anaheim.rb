cask "font-anaheim" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflanaheimAnaheim-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Anaheim"
  homepage "https:fonts.google.comspecimenAnaheim"

  font "Anaheim-Regular.ttf"

  # No zap stanza required
end