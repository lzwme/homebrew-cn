cask "font-actor" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflactorActor-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Actor"
  homepage "https:fonts.google.comspecimenActor"

  font "Actor-Regular.ttf"

  # No zap stanza required
end