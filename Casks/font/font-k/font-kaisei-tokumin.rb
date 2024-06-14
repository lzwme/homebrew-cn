cask "font-kaisei-tokumin" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflkaiseitokumin"
  name "Kaisei Tokumin"
  homepage "https:fonts.google.comspecimenKaisei+Tokumin"

  font "KaiseiTokumin-Bold.ttf"
  font "KaiseiTokumin-ExtraBold.ttf"
  font "KaiseiTokumin-Medium.ttf"
  font "KaiseiTokumin-Regular.ttf"

  # No zap stanza required
end