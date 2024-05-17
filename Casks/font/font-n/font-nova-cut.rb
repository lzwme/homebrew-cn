cask "font-nova-cut" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnovacutNovaCut.ttf",
      verified: "github.comgooglefonts"
  name "Nova Cut"
  homepage "https:fonts.google.comspecimenNova+Cut"

  font "NovaCut.ttf"

  # No zap stanza required
end