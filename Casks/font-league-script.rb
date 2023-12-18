cask "font-league-script" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflleaguescriptLeagueScript-Regular.ttf",
      verified: "github.comgooglefonts"
  name "League Script"
  homepage "https:fonts.google.comspecimenLeague+Script"

  font "LeagueScript-Regular.ttf"

  # No zap stanza required
end