cask "font-zen-kaku-gothic-new" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflzenkakugothicnew"
  name "Zen Kaku Gothic New"
  homepage "https:fonts.google.comspecimenZen+Kaku+Gothic+New"

  font "ZenKakuGothicNew-Black.ttf"
  font "ZenKakuGothicNew-Bold.ttf"
  font "ZenKakuGothicNew-Light.ttf"
  font "ZenKakuGothicNew-Medium.ttf"
  font "ZenKakuGothicNew-Regular.ttf"

  # No zap stanza required
end