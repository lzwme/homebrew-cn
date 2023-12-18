cask "font-raleway-dots" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflralewaydotsRalewayDots-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Raleway Dots"
  homepage "https:fonts.google.comspecimenRaleway+Dots"

  font "RalewayDots-Regular.ttf"

  # No zap stanza required
end