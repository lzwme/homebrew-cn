cask "font-oleo-script" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofloleoscript"
  name "Oleo Script"
  homepage "https:fonts.google.comspecimenOleo+Script"

  font "OleoScript-Bold.ttf"
  font "OleoScript-Regular.ttf"

  # No zap stanza required
end