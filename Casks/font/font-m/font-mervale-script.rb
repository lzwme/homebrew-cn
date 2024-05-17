cask "font-mervale-script" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmervalescriptMervaleScript-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Mervale Script"
  homepage "https:fonts.google.comspecimenMervale+Script"

  font "MervaleScript-Regular.ttf"

  # No zap stanza required
end