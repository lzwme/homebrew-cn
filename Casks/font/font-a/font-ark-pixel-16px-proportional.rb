cask "font-ark-pixel-16px-proportional" do
  version "2025.03.14"
  sha256 "9d8174e9bebf664a06b49651ba08b1e46ce4bea54e91fcacd429c61c6d4f7b23"

  url "https:github.comTakWolfark-pixel-fontreleasesdownload#{version}ark-pixel-font-16px-proportional-otf-v#{version}.zip"
  name "Ark Pixel 16px Proportional"
  homepage "https:github.comTakWolfark-pixel-font"

  no_autobump! because: :requires_manual_review

  font "ark-pixel-16px-proportional-ja.otf"
  font "ark-pixel-16px-proportional-ko.otf"
  font "ark-pixel-16px-proportional-latin.otf"
  font "ark-pixel-16px-proportional-zh_cn.otf"
  font "ark-pixel-16px-proportional-zh_hk.otf"
  font "ark-pixel-16px-proportional-zh_tr.otf"
  font "ark-pixel-16px-proportional-zh_tw.otf"

  # No zap stanza required
end