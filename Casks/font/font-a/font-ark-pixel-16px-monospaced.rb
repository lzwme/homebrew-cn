cask "font-ark-pixel-16px-monospaced" do
  version "2025.03.14"
  sha256 "52c0ba223db329f3858e8572ca0ab07fe8b6e46981566add5bde860180432cc7"

  url "https:github.comTakWolfark-pixel-fontreleasesdownload#{version}ark-pixel-font-16px-monospaced-otf-v#{version}.zip"
  name "Ark Pixel 16px Monospaced"
  homepage "https:github.comTakWolfark-pixel-font"

  font "ark-pixel-16px-monospaced-ja.otf"
  font "ark-pixel-16px-monospaced-ko.otf"
  font "ark-pixel-16px-monospaced-latin.otf"
  font "ark-pixel-16px-monospaced-zh_cn.otf"
  font "ark-pixel-16px-monospaced-zh_hk.otf"
  font "ark-pixel-16px-monospaced-zh_tr.otf"
  font "ark-pixel-16px-monospaced-zh_tw.otf"

  # No zap stanza required
end