cask "font-imperial-script" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflimperialscriptImperialScript-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Imperial Script"
  desc "Formal script font with clean connections and an elegant look"
  homepage "https:fonts.google.comspecimenImperial+Script"

  font "ImperialScript-Regular.ttf"

  # No zap stanza required
end