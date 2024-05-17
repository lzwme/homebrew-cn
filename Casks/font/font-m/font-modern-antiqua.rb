cask "font-modern-antiqua" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmodernantiquaModernAntiqua-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Modern Antiqua"
  homepage "https:fonts.google.comspecimenModern+Antiqua"

  font "ModernAntiqua-Regular.ttf"

  # No zap stanza required
end