cask "font-gfs-neohellenic" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflgfsneohellenic"
  name "GFS Neohellenic"
  homepage "https:fonts.google.comspecimenGFS+Neohellenic"

  font "GFSNeohellenic.ttf"
  font "GFSNeohellenicBold.ttf"
  font "GFSNeohellenicBoldItalic.ttf"
  font "GFSNeohellenicItalic.ttf"

  # No zap stanza required
end