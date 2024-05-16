cask "font-bungee-shade" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbungeeshadeBungeeShade-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bungee Shade"
  homepage "https:fonts.google.comspecimenBungee+Shade"

  font "BungeeShade-Regular.ttf"

  # No zap stanza required
end