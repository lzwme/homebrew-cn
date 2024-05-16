cask "font-fraunces" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflfraunces"
  name "Fraunces"
  desc "Variable font with four axes"
  homepage "https:fonts.google.comspecimenFraunces"

  font "Fraunces-Italic[SOFT,WONK,opsz,wght].ttf"
  font "Fraunces[SOFT,WONK,opsz,wght].ttf"

  # No zap stanza required
end