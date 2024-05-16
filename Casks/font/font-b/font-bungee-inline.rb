cask "font-bungee-inline" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbungeeinlineBungeeInline-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bungee Inline"
  homepage "https:fonts.google.comspecimenBungee+Inline"

  font "BungeeInline-Regular.ttf"

  # No zap stanza required
end