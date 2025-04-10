cask "font-special-gothic" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflspecialgothicSpecialGothic-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Special Gothic"
  homepage "https:fonts.google.comspecimenSpecial+Gothic"

  font "SpecialGothic-Regular.ttf"

  # No zap stanza required
end