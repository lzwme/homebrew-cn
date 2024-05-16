cask "font-hanalei-fill" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflhanaleifillHanaleiFill-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Hanalei Fill"
  homepage "https:fonts.google.comspecimenHanalei+Fill"

  font "HanaleiFill-Regular.ttf"

  # No zap stanza required
end