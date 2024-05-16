cask "font-lobster-two" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofllobstertwo"
  name "Lobster Two"
  homepage "https:fonts.google.comspecimenLobster+Two"

  font "LobsterTwo-Bold.ttf"
  font "LobsterTwo-BoldItalic.ttf"
  font "LobsterTwo-Italic.ttf"
  font "LobsterTwo-Regular.ttf"

  # No zap stanza required
end