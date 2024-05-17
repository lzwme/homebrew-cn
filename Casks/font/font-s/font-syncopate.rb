cask "font-syncopate" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "apachesyncopate"
  name "Syncopate"
  homepage "https:fonts.google.comspecimenSyncopate"

  font "Syncopate-Bold.ttf"
  font "Syncopate-Regular.ttf"

  # No zap stanza required
end