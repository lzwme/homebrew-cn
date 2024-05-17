cask "font-meddon" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmeddonMeddon.ttf",
      verified: "github.comgooglefonts"
  name "Meddon"
  homepage "https:fonts.google.comspecimenMeddon"

  font "Meddon.ttf"

  # No zap stanza required
end