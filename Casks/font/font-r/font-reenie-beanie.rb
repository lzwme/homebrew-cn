cask "font-reenie-beanie" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflreeniebeanieReenieBeanie.ttf",
      verified: "github.comgooglefonts"
  name "Reenie Beanie"
  homepage "https:fonts.google.comspecimenReenie+Beanie"

  font "ReenieBeanie.ttf"

  # No zap stanza required
end