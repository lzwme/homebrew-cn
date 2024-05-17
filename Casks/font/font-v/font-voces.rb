cask "font-voces" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflvocesVoces-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Voces"
  homepage "https:fonts.google.comspecimenVoces"

  font "Voces-Regular.ttf"

  # No zap stanza required
end