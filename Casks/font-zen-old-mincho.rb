cask "font-zen-old-mincho" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflzenoldmincho"
  name "Zen Old Mincho"
  desc "Intended for text usage, it also works well in large sizes"
  homepage "https:fonts.google.comspecimenZen+Old+Mincho"

  font "ZenOldMincho-Black.ttf"
  font "ZenOldMincho-Bold.ttf"
  font "ZenOldMincho-Medium.ttf"
  font "ZenOldMincho-Regular.ttf"
  font "ZenOldMincho-SemiBold.ttf"

  # No zap stanza required
end