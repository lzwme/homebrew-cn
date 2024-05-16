cask "font-bungee-hairline" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbungeehairlineBungeeHairline-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bungee Hairline"
  homepage "https:fonts.google.comspecimenBungee+Hairline"

  font "BungeeHairline-Regular.ttf"

  # No zap stanza required
end