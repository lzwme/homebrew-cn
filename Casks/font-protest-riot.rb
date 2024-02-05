cask "font-protest-riot" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflprotestriotProtestRiot-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Protest Riot"
  homepage "https:fonts.google.comspecimenProtest+Riot"

  font "ProtestRiot-Regular.ttf"

  # No zap stanza required
end