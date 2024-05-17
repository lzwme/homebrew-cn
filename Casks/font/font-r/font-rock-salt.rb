cask "font-rock-salt" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapacherocksaltRockSalt-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rock Salt"
  homepage "https:fonts.google.comspecimenRock+Salt"

  font "RockSalt-Regular.ttf"

  # No zap stanza required
end