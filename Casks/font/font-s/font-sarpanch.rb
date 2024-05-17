cask "font-sarpanch" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsarpanch"
  name "Sarpanch"
  homepage "https:fonts.google.comspecimenSarpanch"

  font "Sarpanch-Black.ttf"
  font "Sarpanch-Bold.ttf"
  font "Sarpanch-ExtraBold.ttf"
  font "Sarpanch-Medium.ttf"
  font "Sarpanch-Regular.ttf"
  font "Sarpanch-SemiBold.ttf"

  # No zap stanza required
end