cask "font-biz-udpgothic" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbizudpgothic"
  name "BIZ UDPGothic"
  homepage "https:fonts.google.comspecimenBIZ+UDPGothic"

  font "BIZUDPGothic-Bold.ttf"
  font "BIZUDPGothic-Regular.ttf"

  # No zap stanza required
end