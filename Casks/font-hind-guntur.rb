cask "font-hind-guntur" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflhindguntur"
  name "Hind Guntur"
  homepage "https:fonts.google.comspecimenHind+Guntur"

  font "HindGuntur-Bold.ttf"
  font "HindGuntur-Light.ttf"
  font "HindGuntur-Medium.ttf"
  font "HindGuntur-Regular.ttf"
  font "HindGuntur-SemiBold.ttf"

  # No zap stanza required
end