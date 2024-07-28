cask "font-chiron-hei-hk" do
  version "2.513"
  sha256 "15fe06ac6d420ee150c038afb4bd45ee5e3629da12a72dd22ae6e95d3d8c4651"

  url "https:github.comchiron-fontschiron-hei-hkarchiverefstagsv#{version}.tar.gz"
  name "Chiron Hei HK"
  name "昭源黑體"
  homepage "https:github.comchiron-fontschiron-hei-hk"

  font "chiron-hei-hk-#{version}VARChironHeiHKItVF.otf"
  font "chiron-hei-hk-#{version}VARChironHeiHKVF.otf"

  # No zap stanza required
end