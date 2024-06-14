cask "font-stick" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflstickStick-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Stick"
  homepage "https:fonts.google.comspecimenStick"

  font "Stick-Regular.ttf"

  # No zap stanza required
end