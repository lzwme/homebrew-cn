cask "font-monoton" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmonotonMonoton-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Monoton"
  homepage "https:fonts.google.comspecimenMonoton"

  font "Monoton-Regular.ttf"

  # No zap stanza required
end