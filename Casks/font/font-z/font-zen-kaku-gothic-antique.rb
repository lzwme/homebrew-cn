cask "font-zen-kaku-gothic-antique" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflzenkakugothicantique"
  name "Zen Kaku Gothic Antique"
  desc "Classical yet simple and stylish version"
  homepage "https:fonts.google.comspecimenZen+Kaku+Gothic+Antique"

  font "ZenKakuGothicAntique-Black.ttf"
  font "ZenKakuGothicAntique-Bold.ttf"
  font "ZenKakuGothicAntique-Light.ttf"
  font "ZenKakuGothicAntique-Medium.ttf"
  font "ZenKakuGothicAntique-Regular.ttf"

  # No zap stanza required
end