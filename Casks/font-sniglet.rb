cask "font-sniglet" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsniglet"
  name "Sniglet"
  homepage "https:fonts.google.comspecimenSniglet"

  font "Sniglet-ExtraBold.ttf"
  font "Sniglet-Regular.ttf"

  # No zap stanza required
end