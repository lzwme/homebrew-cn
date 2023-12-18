cask "font-chiron-hei-hk" do
  version "2.509"
  sha256 "fcbea8df23150df74f52507d8fa6bc4f6aa941aa7d974743794a0b10a1378012"

  url "https:github.comchiron-fontschiron-hei-hkarchiverefstagsv#{version}.zip"
  name "Chiron Hei HK"
  name "昭源黑體"
  desc "Modern, region-agnostic traditional Chinese sans serif typeface"
  homepage "https:github.comchiron-fontschiron-hei-hk"

  font "chiron-hei-hk-#{version}VARChironHeiHKItVF.otf"
  font "chiron-hei-hk-#{version}VARChironHeiHKVF.otf"

  # No zap stanza required
end