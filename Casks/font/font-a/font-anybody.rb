cask "font-anybody" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflanybody"
  name "Anybody"
  desc "10 degrees, noticable but subtle"
  homepage "https:fonts.google.comspecimenAnybody"

  font "Anybody-Italic[wdth,wght].ttf"
  font "Anybody[wdth,wght].ttf"

  # No zap stanza required
end