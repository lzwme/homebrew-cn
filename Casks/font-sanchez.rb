cask "font-sanchez" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsanchez"
  name "Sanchez"
  homepage "https:fonts.google.comspecimenSanchez"

  font "Sanchez-Italic.ttf"
  font "Sanchez-Regular.ttf"

  # No zap stanza required
end