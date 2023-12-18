cask "font-rethink-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflrethinksans"
  name "Rethink Sans"
  desc "Sans-serif type family"
  homepage "https:fonts.google.comspecimenRethink+Sans"

  font "RethinkSans-Italic[wght].ttf"
  font "RethinkSans[wght].ttf"

  # No zap stanza required
end