cask "font-signika-negative-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsignikanegativesc"
  name "Signika Negative SC"
  homepage "https:fonts.google.comspecimenSignika+Negative"

  font "SignikaNegativeSC-Bold.ttf"
  font "SignikaNegativeSC-Light.ttf"
  font "SignikaNegativeSC-Regular.ttf"
  font "SignikaNegativeSC-SemiBold.ttf"

  # No zap stanza required
end