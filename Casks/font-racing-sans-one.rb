cask "font-racing-sans-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflracingsansoneRacingSansOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Racing Sans One"
  homepage "https:fonts.google.comspecimenRacing+Sans+One"

  font "RacingSansOne-Regular.ttf"

  # No zap stanza required
end