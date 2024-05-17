cask "font-splash" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsplashSplash-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Splash"
  homepage "https:fonts.google.comspecimenSplash"

  font "Splash-Regular.ttf"

  # No zap stanza required
end