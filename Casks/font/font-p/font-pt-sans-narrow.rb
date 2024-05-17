cask "font-pt-sans-narrow" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflptsansnarrow"
  name "PT Sans Narrow"
  homepage "https:fonts.google.comspecimenPT+Sans+Narrow"

  font "PT_Sans-Narrow-Web-Bold.ttf"
  font "PT_Sans-Narrow-Web-Regular.ttf"

  # No zap stanza required
end