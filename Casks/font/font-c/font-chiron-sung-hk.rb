cask "font-chiron-sung-hk" do
  version "1.019"
  sha256 "ba50c6c87507f369398cf628c31e98bb4c52819079a46e5cc0c5d3f16a78eaad"

  url "https:github.comchiron-fontschiron-sung-hkarchiverefstagsv#{version}.tar.gz"
  name "Chiron Sung HK"
  name "昭源宋體"
  homepage "https:github.comchiron-fontschiron-sung-hk"

  font "chiron-sung-hk-#{version}VARChironSungHKItVF.otf"
  font "chiron-sung-hk-#{version}VARChironSungHKVF.otf"

  # No zap stanza required
end