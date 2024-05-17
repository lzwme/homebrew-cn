cask "font-nova-oval" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnovaovalNovaOval.ttf",
      verified: "github.comgooglefonts"
  name "Nova Oval"
  homepage "https:fonts.google.comspecimenNova+Oval"

  font "NovaOval.ttf"

  # No zap stanza required
end