cask "font-wellfleet" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflwellfleetWellfleet-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Wellfleet"
  homepage "https:fonts.google.comspecimenWellfleet"

  font "Wellfleet-Regular.ttf"

  # No zap stanza required
end