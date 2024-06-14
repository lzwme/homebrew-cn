cask "font-chiron-hei-hk" do
  version "2.510"
  sha256 "9370001503f3d8c6010774d261b690f19762d8d7ab7877890310a5151dfa5a85"

  url "https:github.comchiron-fontschiron-hei-hkarchiverefstagsv#{version}.zip"
  name "Chiron Hei HK"
  name "昭源黑體"
  homepage "https:github.comchiron-fontschiron-hei-hk"

  font "chiron-hei-hk-#{version}VARChironHeiHKItVF.otf"
  font "chiron-hei-hk-#{version}VARChironHeiHKVF.otf"

  # No zap stanza required
end