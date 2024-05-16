cask "font-glass-antiqua" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflglassantiquaGlassAntiqua-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Glass Antiqua"
  homepage "https:fonts.google.comspecimenGlass+Antiqua"

  font "GlassAntiqua-Regular.ttf"

  # No zap stanza required
end