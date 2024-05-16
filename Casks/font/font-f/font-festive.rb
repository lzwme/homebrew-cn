cask "font-festive" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfestiveFestive-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Festive"
  homepage "https:fonts.google.comspecimenFestive"

  font "Festive-Regular.ttf"

  # No zap stanza required
end