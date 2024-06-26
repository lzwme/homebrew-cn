cask "font-balsamiq-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbalsamiqsans"
  name "Balsamiq Sans"
  homepage "https:balsamiq.comgivingbackopensourcefont"

  font "BalsamiqSans-Bold.ttf"
  font "BalsamiqSans-BoldItalic.ttf"
  font "BalsamiqSans-Italic.ttf"
  font "BalsamiqSans-Regular.ttf"

  # No zap stanza required
end