cask "font-ark-pixel-12px-proportional" do
  version "2024.05.12"
  sha256 "974051438973ce439f36e9646f4d175432f6585a84354d4925f0fced8b925a6e"

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