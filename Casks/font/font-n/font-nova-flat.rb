cask "font-nova-flat" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnovaflatNovaFlat.ttf",
      verified: "github.comgooglefonts"
  name "Nova Flat"
  homepage "https:fonts.google.comspecimenNova+Flat"

  font "NovaFlat.ttf"

  # No zap stanza required
end