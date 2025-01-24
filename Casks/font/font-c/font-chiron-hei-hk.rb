cask "font-chiron-hei-hk" do
  version "2.523"
  sha256 "0242ad0803bdf8d7e55eff2b2bb8b23619c9b6579d607a74e767d1c9c97099e6"

  url "https:github.comchiron-fontschiron-hei-hkarchiverefstagsv#{version}.tar.gz"
  name "Chiron Hei HK"
  name "昭源黑體"
  homepage "https:github.comchiron-fontschiron-hei-hk"

  font "chiron-hei-hk-#{version}VARChironHeiHKItVF.otf"
  font "chiron-hei-hk-#{version}VARChironHeiHKVF.otf"

  # No zap stanza required
end