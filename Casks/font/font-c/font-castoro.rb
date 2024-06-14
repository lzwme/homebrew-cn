cask "font-castoro" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcastoro"
  name "Castoro"
  homepage "https:fonts.google.comspecimenCastoro"

  font "Castoro-Italic.ttf"
  font "Castoro-Regular.ttf"

  # No zap stanza required
end