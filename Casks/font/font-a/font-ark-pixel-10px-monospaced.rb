cask "font-ark-pixel-10px-monospaced" do
  version "2024.05.12"
  sha256 "b36dba594dbdb21200d4b810a84db487b7b724a60890331da45853279e01ab2a"

  url "https:github.comTakWolfark-pixel-fontreleasesdownload#{version}ark-pixel-font-10px-monospaced-otf-v#{version}.zip"
  name "Ark Pixel 10px Monospaced"
  desc "Open source Pan-CJK pixel font"
  homepage "https:github.comTakWolfark-pixel-font"

  font "ark-pixel-10px-monospaced-ja.otf"
  font "ark-pixel-10px-monospaced-ko.otf"
  font "ark-pixel-10px-monospaced-latin.otf"
  font "ark-pixel-10px-monospaced-zh_cn.otf"
  font "ark-pixel-10px-monospaced-zh_hk.otf"
  font "ark-pixel-10px-monospaced-zh_tr.otf"
  font "ark-pixel-10px-monospaced-zh_tw.otf"

  # No zap stanza required
end