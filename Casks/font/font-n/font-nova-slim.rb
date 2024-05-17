cask "font-nova-slim" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnovaslimNovaSlim.ttf",
      verified: "github.comgooglefonts"
  name "Nova Slim"
  homepage "https:fonts.google.comspecimenNova+Slim"

  font "NovaSlim.ttf"

  # No zap stanza required
end