cask "font-mountains-of-christmas" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "apachemountainsofchristmas"
  name "Mountains of Christmas"
  homepage "https:fonts.google.comspecimenMountains+of+Christmas"

  font "MountainsofChristmas-Bold.ttf"
  font "MountainsofChristmas-Regular.ttf"

  # No zap stanza required
end