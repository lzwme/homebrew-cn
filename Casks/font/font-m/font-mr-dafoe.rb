cask "font-mr-dafoe" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmrdafoeMrDafoe-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Mr Dafoe"
  homepage "https:fonts.google.comspecimenMr+Dafoe"

  font "MrDafoe-Regular.ttf"

  # No zap stanza required
end