cask "font-petemoss" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpetemossPetemoss-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Petemoss"
  desc "Inspired by the forms created using a pentel color brush"
  homepage "https:fonts.google.comspecimenPetemoss"

  font "Petemoss-Regular.ttf"

  # No zap stanza required
end