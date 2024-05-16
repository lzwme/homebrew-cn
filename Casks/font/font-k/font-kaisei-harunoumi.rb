cask "font-kaisei-harunoumi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflkaiseiharunoumi"
  name "Kaisei HarunoUmi"
  homepage "https:fonts.google.comspecimenKaisei+HarunoUmi"

  font "KaiseiHarunoUmi-Bold.ttf"
  font "KaiseiHarunoUmi-Medium.ttf"
  font "KaiseiHarunoUmi-Regular.ttf"

  # No zap stanza required
end