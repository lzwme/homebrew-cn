cask "font-kaisei-decol" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflkaiseidecol"
  name "Kaisei Decol"
  homepage "https:fonts.google.comspecimenKaisei+Decol"

  font "KaiseiDecol-Bold.ttf"
  font "KaiseiDecol-Medium.ttf"
  font "KaiseiDecol-Regular.ttf"

  # No zap stanza required
end