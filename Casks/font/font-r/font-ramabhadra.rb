cask "font-ramabhadra" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflramabhadraRamabhadra-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Ramabhadra"
  homepage "https:fonts.google.comspecimenRamabhadra"

  font "Ramabhadra-Regular.ttf"

  # No zap stanza required
end