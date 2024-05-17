cask "font-montez" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapachemontezMontez-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Montez"
  homepage "https:fonts.google.comspecimenMontez"

  font "Montez-Regular.ttf"

  # No zap stanza required
end