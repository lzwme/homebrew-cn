cask "font-petemoss" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpetemossPetemoss-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Petemoss"
  homepage "https:fonts.google.comspecimenPetemoss"

  font "Petemoss-Regular.ttf"

  # No zap stanza required
end