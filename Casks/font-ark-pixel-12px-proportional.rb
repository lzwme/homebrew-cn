cask "font-ark-pixel-12px-proportional" do
  version "2024.04.05"
  sha256 "2fe2c0bcf1053486ea8506e10cf155487c941cba6b7b899ffa114fa57ee9b3ea"

  url "https:github.comTakWolfark-pixel-fontreleasesdownload#{version}ark-pixel-font-12px-proportional-otf-v#{version}.zip"
  name "Ark Pixel 12px Proportional"
  desc "Open source Pan-CJK pixel font"
  homepage "https:github.comTakWolfark-pixel-font"

  font "ark-pixel-12px-proportional-ja.otf"
  font "ark-pixel-12px-proportional-ko.otf"
  font "ark-pixel-12px-proportional-latin.otf"
  font "ark-pixel-12px-proportional-zh_cn.otf"
  font "ark-pixel-12px-proportional-zh_hk.otf"
  font "ark-pixel-12px-proportional-zh_tr.otf"
  font "ark-pixel-12px-proportional-zh_tw.otf"

  # No zap stanza required
end