cask "font-stoke" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflstoke"
  name "Stoke"
  homepage "https:fonts.google.comspecimenStoke"

  font "Stoke-Light.ttf"
  font "Stoke-Regular.ttf"

  # No zap stanza required
end