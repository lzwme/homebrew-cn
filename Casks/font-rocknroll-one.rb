cask "font-rocknroll-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrocknrolloneRocknRollOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "RocknRoll One"
  homepage "https:fonts.google.comspecimenRocknRoll+One"

  font "RocknRollOne-Regular.ttf"

  # No zap stanza required
end