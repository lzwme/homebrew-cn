cask "font-ark-pixel-16px-proportional" do
  version "2025.07.21"
  sha256 "9cd6512196d18e6577b63c19fb1a961e86d95884d6e8ae2effa38fc7c652ed06"

  url "https://ghfast.top/https://github.com/TakWolf/ark-pixel-font/releases/download/#{version}/ark-pixel-font-16px-proportional-otf-v#{version}.zip"
  name "Ark Pixel 16px Proportional"
  homepage "https://github.com/TakWolf/ark-pixel-font"

  font "ark-pixel-16px-proportional-ja.otf"
  font "ark-pixel-16px-proportional-ko.otf"
  font "ark-pixel-16px-proportional-latin.otf"
  font "ark-pixel-16px-proportional-zh_cn.otf"
  font "ark-pixel-16px-proportional-zh_hk.otf"
  font "ark-pixel-16px-proportional-zh_tr.otf"
  font "ark-pixel-16px-proportional-zh_tw.otf"

  # No zap stanza required
end