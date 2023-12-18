cask "font-righteous" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrighteousRighteous-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Righteous"
  homepage "https:fonts.google.comspecimenRighteous"

  font "Righteous-Regular.ttf"

  # No zap stanza required
end