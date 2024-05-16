cask "font-balsamiq-sans" do
  version :latest
  sha256 :no_check

  url "https:github.combalsamiqbalsamiqsansarchivemaster.zip",
      verified: "github.combalsamiqbalsamiqsans"
  name "Balsamiq Sans"
  homepage "https:balsamiq.comgivingbackopensourcefont"

  font "balsamiqsans-masterfontsttfBalsamiqSans-Bold.ttf"
  font "balsamiqsans-masterfontsttfBalsamiqSans-BoldItalic.ttf"
  font "balsamiqsans-masterfontsttfBalsamiqSans-Italic.ttf"
  font "balsamiqsans-masterfontsttfBalsamiqSans-Regular.ttf"

  # No zap stanza required
end