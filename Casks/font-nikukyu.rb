cask "font-nikukyu" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnikukyuNikukyu-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Nikukyu"
  homepage "https:fonts.google.comspecimenNikukyu"

  font "Nikukyu-Regular.ttf"

  # No zap stanza required
end