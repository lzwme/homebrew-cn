cask "font-chiron-hei-hk" do
  version "2.524"
  sha256 "c0986417e2778e87516ed956b31a82457dad10136cb5f737d3df30c4f003b57c"

  url "https:github.comchiron-fontschiron-hei-hkarchiverefstagsv#{version}.tar.gz"
  name "Chiron Hei HK"
  name "昭源黑體"
  homepage "https:github.comchiron-fontschiron-hei-hk"

  font "chiron-hei-hk-#{version}VARChironHeiHKItVF.otf"
  font "chiron-hei-hk-#{version}VARChironHeiHKVF.otf"

  # No zap stanza required
end