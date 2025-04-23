cask "font-chiron-sung-hk" do
  version "1.018"
  sha256 "bc64dd43e919c6d5628b9cafbdb3119d8a86321a0327be0a9ac15ba41bb54468"

  url "https:github.comchiron-fontschiron-sung-hkarchiverefstagsv#{version}.tar.gz"
  name "Chiron Sung HK"
  name "昭源宋體"
  homepage "https:github.comchiron-fontschiron-sung-hk"

  font "chiron-sung-hk-#{version}VARChironSungHKItVF.otf"
  font "chiron-sung-hk-#{version}VARChironSungHKVF.otf"

  # No zap stanza required
end