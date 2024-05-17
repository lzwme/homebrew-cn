cask "font-tiro-bangla" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofltirobangla"
  name "Tiro Bangla"
  desc "Suited to traditional literary publishing"
  homepage "https:fonts.google.comspecimenTiro+Bangla"

  font "TiroBangla-Italic.ttf"
  font "TiroBangla-Regular.ttf"

  # No zap stanza required
end