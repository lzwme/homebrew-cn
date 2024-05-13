cask "font-ark-pixel-12px-monospaced" do
  version "2024.05.12"
  sha256 "2780a0c1ebf0c9bad784d4452b61e00aa262d7429d6eed21c0f944e040409c93"

  url "https:github.comTakWolfark-pixel-fontreleasesdownload#{version}ark-pixel-font-12px-monospaced-otf-v#{version}.zip"
  name "Ark Pixel 12px Monospaced"
  desc "Open source Pan-CJK pixel font"
  homepage "https:github.comTakWolfark-pixel-font"

  font "ark-pixel-12px-monospaced-ja.otf"
  font "ark-pixel-12px-monospaced-ko.otf"
  font "ark-pixel-12px-monospaced-latin.otf"
  font "ark-pixel-12px-monospaced-zh_cn.otf"
  font "ark-pixel-12px-monospaced-zh_hk.otf"
  font "ark-pixel-12px-monospaced-zh_tr.otf"
  font "ark-pixel-12px-monospaced-zh_tw.otf"

  # No zap stanza required
end