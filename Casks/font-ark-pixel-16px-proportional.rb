cask "font-ark-pixel-16px-proportional" do
  version "2024.04.05"
  sha256 "7a227fbdb381670f46749d2415033cac1b73420ddfb813d823d8092891263f70"

  url "https:github.comTakWolfark-pixel-fontreleasesdownload#{version}ark-pixel-font-16px-proportional-otf-v#{version}.zip"
  name "Ark Pixel 16px Proportional"
  desc "Open source Pan-CJK pixel font"
  homepage "https:github.comTakWolfark-pixel-font"

  font "ark-pixel-16px-proportional-ja.otf"
  font "ark-pixel-16px-proportional-ko.otf"
  font "ark-pixel-16px-proportional-latin.otf"
  font "ark-pixel-16px-proportional-zh_cn.otf"
  font "ark-pixel-16px-proportional-zh_hk.otf"
  font "ark-pixel-16px-proportional-zh_tr.otf"
  font "ark-pixel-16px-proportional-zh_tw.otf"

  # No zap stanza required
end