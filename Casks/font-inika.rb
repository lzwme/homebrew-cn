cask "font-inika" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflinika"
  name "Inika"
  homepage "https:fonts.google.comspecimenInika"

  font "Inika-Bold.ttf"
  font "Inika-Regular.ttf"

  # No zap stanza required
end