cask "font-magra" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflmagra"
  name "Magra"
  homepage "https:fonts.google.comspecimenMagra"

  font "Magra-Bold.ttf"
  font "Magra-Regular.ttf"

  # No zap stanza required
end