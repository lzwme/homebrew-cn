cask "font-clicker-script" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflclickerscriptClickerScript-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Clicker Script"
  homepage "https:fonts.google.comspecimenClicker+Script"

  font "ClickerScript-Regular.ttf"

  # No zap stanza required
end