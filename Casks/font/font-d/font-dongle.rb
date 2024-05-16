cask "font-dongle" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofldongle"
  name "Dongle"
  homepage "https:fonts.google.comspecimenDongle"

  font "Dongle-Bold.ttf"
  font "Dongle-Light.ttf"
  font "Dongle-Regular.ttf"

  # No zap stanza required
end