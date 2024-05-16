cask "font-jockey-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofljockeyoneJockeyOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Jockey One"
  homepage "https:fonts.google.comspecimenJockey+One"

  font "JockeyOne-Regular.ttf"

  # No zap stanza required
end