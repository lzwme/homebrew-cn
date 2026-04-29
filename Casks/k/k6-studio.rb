cask "k6-studio" do
  arch arm: "arm64", intel: "x64"

  version "1.13.0"
  sha256 arm:   "e9670bc1d3badbddac732663a3411f40a1821a3637611f9c24cb366d9fedaefa",
         intel: "01907147e11113a5e1af99b5222e1e291f6c05521e0b9f17d1e013d2ff67ad30"

  url "https://ghfast.top/https://github.com/grafana/k6-studio/releases/download/v#{version}/k6.Studio-#{version}-#{arch}.dmg",
      verified: "github.com/grafana/k6-studio/"
  name "k6 Studio"
  desc "Application for generating k6 test scripts"
  homepage "https://grafana.com/docs/k6-studio"

  auto_updates true
  depends_on macos: ">= :monterey"

  app "k6 Studio.app"

  zap trash: [
        "~/Library/Application Support/k6 Studio",
        "~/Library/Caches/com.electron.k6-studio",
        "~/Library/Caches/com.electron.k6-studio.ShipIt",
        "~/Library/HTTPStorages/com.electron.k6-studio",
        "~/Library/Logs/k6 Studio",
        "~/Library/Preferences/com.electron.k6-studio",
        "~/Library/Saved Application State/com.electron.k6-studio.savedState",
      ],
      rmdir: "~/Documents/k6-studio"
end