cask "font-sketchybar-app-font" do
  version "3.0.25"
  sha256 "486ba6dfe7e216148be792793a6ad698f6fc4e1818522442c457f0fcd1cd6393"

  url "https://ghfast.top/https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v#{version}/sketchybar-app-font.ttf"
  name "sketchybar-app-font"
  homepage "https://github.com/kvndrsslr/sketchybar-app-font"

  font "sketchybar-app-font.ttf"

  zap :not_required
end