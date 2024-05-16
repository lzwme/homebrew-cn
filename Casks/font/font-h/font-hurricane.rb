cask "font-hurricane" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflhurricaneHurricane-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Hurricane"
  homepage "https:fonts.google.comspecimenHurricane"

  font "Hurricane-Regular.ttf"

  # No zap stanza required
end