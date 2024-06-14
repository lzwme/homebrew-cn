cask "font-kiwi-maru" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflkiwimaru"
  name "Kiwi Maru"
  homepage "https:fonts.google.comspecimenKiwi+Maru"

  font "KiwiMaru-Light.ttf"
  font "KiwiMaru-Medium.ttf"
  font "KiwiMaru-Regular.ttf"

  # No zap stanza required
end