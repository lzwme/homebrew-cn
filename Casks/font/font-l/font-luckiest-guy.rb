cask "font-luckiest-guy" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapacheluckiestguyLuckiestGuy-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Luckiest Guy"
  homepage "https:fonts.google.comspecimenLuckiest+Guy"

  font "LuckiestGuy-Regular.ttf"

  # No zap stanza required
end