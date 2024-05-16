cask "font-bungee-spice" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbungeespiceBungeeSpice-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bungee Spice"
  desc "Released under the sil open font license"
  homepage "https:fonts.google.comspecimenBungee+Spice"

  font "BungeeSpice-Regular.ttf"

  # No zap stanza required
end