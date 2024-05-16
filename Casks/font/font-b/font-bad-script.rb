cask "font-bad-script" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbadscriptBadScript-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bad Script"
  homepage "https:fonts.google.comspecimenBad+Script"

  font "BadScript-Regular.ttf"

  # No zap stanza required
end