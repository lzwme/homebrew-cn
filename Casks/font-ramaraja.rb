cask "font-ramaraja" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflramarajaRamaraja-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Ramaraja"
  homepage "https:fonts.google.comspecimenRamaraja"

  font "Ramaraja-Regular.ttf"

  # No zap stanza required
end