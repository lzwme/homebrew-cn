cask "font-scheherazade-new" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflscheherazadenew"
  name "Scheherazade New"
  desc "Named after the heroine of the classic arabian nights tale"
  homepage "https:fonts.google.comspecimenScheherazade+New"

  font "ScheherazadeNew-Bold.ttf"
  font "ScheherazadeNew-Medium.ttf"
  font "ScheherazadeNew-Regular.ttf"
  font "ScheherazadeNew-SemiBold.ttf"

  # No zap stanza required
end