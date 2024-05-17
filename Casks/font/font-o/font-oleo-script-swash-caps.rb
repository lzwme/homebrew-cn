cask "font-oleo-script-swash-caps" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofloleoscriptswashcaps"
  name "Oleo Script Swash Caps"
  homepage "https:fonts.google.comspecimenOleo+Script+Swash+Caps"

  font "OleoScriptSwashCaps-Bold.ttf"
  font "OleoScriptSwashCaps-Regular.ttf"

  # No zap stanza required
end