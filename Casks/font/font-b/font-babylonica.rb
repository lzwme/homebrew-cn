cask "font-babylonica" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbabylonicaBabylonica-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Babylonica"
  homepage "https:fonts.google.comspecimenBabylonica"

  font "Babylonica-Regular.ttf"

  # No zap stanza required
end