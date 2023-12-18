cask "font-chilanka" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflchilankaChilanka-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Chilanka"
  homepage "https:fonts.google.comspecimenChilanka"

  font "Chilanka-Regular.ttf"

  # No zap stanza required
end