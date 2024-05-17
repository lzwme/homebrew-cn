cask "font-niconne" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflniconneNiconne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Niconne"
  homepage "https:fonts.google.comspecimenNiconne"

  font "Niconne-Regular.ttf"

  # No zap stanza required
end