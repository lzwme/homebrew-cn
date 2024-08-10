cask "font-chiron-sung-hk" do
  version "1.014"
  sha256 "261e1d97d89764a5807c392aff7a3225d90e7580783245afe9df0497da402d2b"

  url "https:github.comchiron-fontschiron-sung-hkarchiverefstagsv#{version}.tar.gz"
  name "Chiron Sung HK"
  name "昭源宋體"
  homepage "https:github.comchiron-fontschiron-sung-hk"

  font "chiron-sung-hk-#{version}VARChironSungHKItVF.otf"
  font "chiron-sung-hk-#{version}VARChironSungHKVF.otf"

  # No zap stanza required
end