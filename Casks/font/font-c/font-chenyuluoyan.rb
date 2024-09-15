cask "font-chenyuluoyan" do
  version "1.0"
  sha256 "d8ecd0598634c92f0b29f90aabef8f7916f17aef19b0350883ca7b46979a5373"

  url "https:github.comChenyu-otfchenyuluoyan_thinreleasesdownloadv#{version}-monospacedChenYuluoyan-Thin-Monospaced.ttf"
  name "Chenyuluoyan"
  name "辰宇落雁體"
  homepage "https:github.comChenyu-otfchenyuluoyan_thin"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)[._-]monospaced$i)
  end

  font "ChenYuluoyan-Thin-Monospaced.ttf"

  # No zap stanza required
end