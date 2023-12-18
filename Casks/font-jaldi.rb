cask "font-jaldi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofljaldi"
  name "Jaldi"
  homepage "https:fonts.google.comspecimenJaldi"

  font "Jaldi-Bold.ttf"
  font "Jaldi-Regular.ttf"

  # No zap stanza required
end