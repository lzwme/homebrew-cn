cask "font-cutive-mono" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcutivemonoCutiveMono-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Cutive Mono"
  homepage "https:fonts.google.comspecimenCutive+Mono"

  font "CutiveMono-Regular.ttf"

  # No zap stanza required
end