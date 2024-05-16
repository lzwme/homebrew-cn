cask "font-crete-round" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcreteround"
  name "Crete Round"
  homepage "https:fonts.google.comspecimenCrete+Round"

  font "CreteRound-Italic.ttf"
  font "CreteRound-Regular.ttf"

  # No zap stanza required
end