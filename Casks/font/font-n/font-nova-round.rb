cask "font-nova-round" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnovaroundNovaRound.ttf",
      verified: "github.comgooglefonts"
  name "Nova Round"
  homepage "https:fonts.google.comspecimenNova+Round"

  font "NovaRound.ttf"

  # No zap stanza required
end