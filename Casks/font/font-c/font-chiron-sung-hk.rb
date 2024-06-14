cask "font-chiron-sung-hk" do
  version "1.011"
  sha256 "67334720bcc01e043b9acebcfe6aa5ad023837b89650f448e13ec4274aae9c36"

  url "https:github.comchiron-fontschiron-sung-hkarchiverefstagsv#{version}.zip"
  name "Chiron Sung HK"
  name "昭源宋體"
  homepage "https:github.comchiron-fontschiron-sung-hk"

  font "chiron-sung-hk-#{version}VARChironSungHKItVF.otf"
  font "chiron-sung-hk-#{version}VARChironSungHKVF.otf"

  # No zap stanza required
end