cask "font-imperial-script" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflimperialscriptImperialScript-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Imperial Script"
  homepage "https:fonts.google.comspecimenImperial+Script"

  font "ImperialScript-Regular.ttf"

  # No zap stanza required
end