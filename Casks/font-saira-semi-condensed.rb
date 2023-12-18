cask "font-saira-semi-condensed" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsairasemicondensed"
  name "Saira Semi Condensed"
  homepage "https:fonts.google.comspecimenSaira+Semi+Condensed"

  font "SairaSemiCondensed-Black.ttf"
  font "SairaSemiCondensed-Bold.ttf"
  font "SairaSemiCondensed-ExtraBold.ttf"
  font "SairaSemiCondensed-ExtraLight.ttf"
  font "SairaSemiCondensed-Light.ttf"
  font "SairaSemiCondensed-Medium.ttf"
  font "SairaSemiCondensed-Regular.ttf"
  font "SairaSemiCondensed-SemiBold.ttf"
  font "SairaSemiCondensed-Thin.ttf"

  # No zap stanza required
end