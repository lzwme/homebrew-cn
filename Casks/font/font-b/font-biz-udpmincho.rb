cask "font-biz-udpmincho" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbizudpmincho"
  name "BIZ UDPMincho"
  homepage "https:fonts.google.comspecimenBIZ+UDPMincho"

  font "BIZUDPMincho-Bold.ttf"
  font "BIZUDPMincho-Regular.ttf"

  # No zap stanza required
end