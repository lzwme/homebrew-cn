cask "font-chiron-sung-hk" do
  version "1.011"
  sha256 "67334720bcc01e043b9acebcfe6aa5ad023837b89650f448e13ec4274aae9c36"

  url "https://ghproxy.com/https://github.com/chiron-fonts/chiron-sung-hk/archive/refs/tags/v#{version}.zip"
  name "Chiron Sung HK"
  name "昭源宋體"
  desc "Modern, region-agnostic traditional Chinese serif typeface"
  homepage "https://github.com/chiron-fonts/chiron-sung-hk"

  font "chiron-sung-hk-#{version}/VAR/ChironSungHKItVF.otf"
  font "chiron-sung-hk-#{version}/VAR/ChironSungHKVF.otf"

  # No zap stanza required
end