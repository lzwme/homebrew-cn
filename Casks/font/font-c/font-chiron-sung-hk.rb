cask "font-chiron-sung-hk" do
  version "1.013"
  sha256 "0da92f806a130338de304d17a4bcd0614e394ef22adf2716373264b2d0401b50"

  url "https:github.comchiron-fontschiron-sung-hkarchiverefstagsv#{version}.tar.gz"
  name "Chiron Sung HK"
  name "昭源宋體"
  homepage "https:github.comchiron-fontschiron-sung-hk"

  font "chiron-sung-hk-#{version}VARChironSungHKItVF.otf"
  font "chiron-sung-hk-#{version}VARChironSungHKVF.otf"

  # No zap stanza required
end