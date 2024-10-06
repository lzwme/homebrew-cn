cask "font-bungee-tint" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbungeetintBungeeTint-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bungee Tint"
  homepage "https:fonts.google.comspecimenBungee+Tint"

  font "BungeeTint-Regular.ttf"

  # No zap stanza required
end