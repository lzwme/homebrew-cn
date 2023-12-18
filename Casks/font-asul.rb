cask "font-asul" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflasul"
  name "Asul"
  homepage "https:fonts.google.comspecimenAsul"

  font "Asul-Bold.ttf"
  font "Asul-Regular.ttf"

  # No zap stanza required
end