cask "font-nova-mono" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnovamonoNovaMono.ttf",
      verified: "github.comgooglefonts"
  name "Nova Mono"
  homepage "https:fonts.google.comspecimenNova+Mono"

  font "NovaMono.ttf"

  # No zap stanza required
end