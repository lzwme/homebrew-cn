cask "font-saira-extra-condensed" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsairaextracondensed"
  name "Saira Extra Condensed"
  homepage "https:fonts.google.comspecimenSaira+Extra+Condensed"

  font "SairaExtraCondensed-Black.ttf"
  font "SairaExtraCondensed-Bold.ttf"
  font "SairaExtraCondensed-ExtraBold.ttf"
  font "SairaExtraCondensed-ExtraLight.ttf"
  font "SairaExtraCondensed-Light.ttf"
  font "SairaExtraCondensed-Medium.ttf"
  font "SairaExtraCondensed-Regular.ttf"
  font "SairaExtraCondensed-SemiBold.ttf"
  font "SairaExtraCondensed-Thin.ttf"

  # No zap stanza required
end