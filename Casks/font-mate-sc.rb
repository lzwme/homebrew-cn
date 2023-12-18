cask "font-mate-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmatescMateSC-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Mate SC"
  homepage "https:fonts.google.comspecimenMate+SC"

  font "MateSC-Regular.ttf"

  # No zap stanza required
end