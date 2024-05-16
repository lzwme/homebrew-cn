cask "font-courgette" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcourgetteCourgette-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Courgette"
  homepage "https:fonts.google.comspecimenCourgette"

  font "Courgette-Regular.ttf"

  # No zap stanza required
end