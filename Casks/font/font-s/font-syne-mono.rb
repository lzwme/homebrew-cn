cask "font-syne-mono" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsynemonoSyneMono-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Syne Mono"
  homepage "https:fonts.google.comspecimenSyne+Mono"

  font "SyneMono-Regular.ttf"

  # No zap stanza required
end