cask "font-tiro-telugu" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofltirotelugu"
  name "Tiro Telugu"
  desc "Especially suited to traditional literary publishing"
  homepage "https:fonts.google.comspecimenTiro+Telugu"

  font "TiroTelugu-Italic.ttf"
  font "TiroTelugu-Regular.ttf"

  # No zap stanza required
end