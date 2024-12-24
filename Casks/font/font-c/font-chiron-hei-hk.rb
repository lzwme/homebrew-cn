cask "font-chiron-hei-hk" do
  version "2.521"
  sha256 "506b7c0b3f909c2a37b20a3a7a6065c7dbeb914ef69797137d7d11334448f5aa"

  url "https:github.comchiron-fontschiron-hei-hkarchiverefstagsv#{version}.tar.gz"
  name "Chiron Hei HK"
  name "昭源黑體"
  homepage "https:github.comchiron-fontschiron-hei-hk"

  font "chiron-hei-hk-#{version}VARChironHeiHKItVF.otf"
  font "chiron-hei-hk-#{version}VARChironHeiHKVF.otf"

  # No zap stanza required
end