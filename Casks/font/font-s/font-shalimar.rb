cask "font-shalimar" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflshalimarShalimar-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Shalimar"
  homepage "https:fonts.google.comspecimenShalimar"

  font "Shalimar-Regular.ttf"

  # No zap stanza required
end