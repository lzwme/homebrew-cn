cask "font-chiron-sung-hk" do
  version "1.015"
  sha256 "d3f481773b688e90325127e782a15b10defbe64f69f707deb4b85f8a754e85fb"

  url "https:github.comchiron-fontschiron-sung-hkarchiverefstagsv#{version}.tar.gz"
  name "Chiron Sung HK"
  name "昭源宋體"
  homepage "https:github.comchiron-fontschiron-sung-hk"

  font "chiron-sung-hk-#{version}VARChironSungHKItVF.otf"
  font "chiron-sung-hk-#{version}VARChironSungHKVF.otf"

  # No zap stanza required
end