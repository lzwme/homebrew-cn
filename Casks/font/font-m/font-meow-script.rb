cask "font-meow-script" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmeowscriptMeowScript-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Meow Script"
  homepage "https:fonts.google.comspecimenMeow+Script"

  font "MeowScript-Regular.ttf"

  # No zap stanza required
end