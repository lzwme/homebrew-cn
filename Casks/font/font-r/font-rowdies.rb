cask "font-rowdies" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflrowdies"
  name "Rowdies"
  homepage "https:fonts.google.comspecimenRowdies"

  font "Rowdies-Bold.ttf"
  font "Rowdies-Light.ttf"
  font "Rowdies-Regular.ttf"

  # No zap stanza required
end