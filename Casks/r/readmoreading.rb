cask "readmoreading" do
  arch arm: "arm64", intel: "x64"

  version "1.8.1"
  sha256 arm:   "a62e1b9115c55e2ad8f849972699984722c2f929b1f866ffda61218be934a8d1",
         intel: "cc4e6f73c4adbd0e2e176d871a8f4c08ad21c196e8090f81fdf940ecf7fb0ada"

  url "https://ghfast.top/https://github.com/eCrowdMedia/remake/releases/download/v#{version}/Readmoo.-#{version}-#{arch}.dmg",
      verified: "github.com/eCrowdMedia/remake/"
  name "Readmo Reading"
  desc "Traditional Chinese eBook service"
  homepage "https://readmoo.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  app "Readmoo看書.app"

  zap trash: [
    "~/Library/Application Support/Readmoo看書",
    "~/Library/Caches/com.electron.readmoo",
    "~/Library/Caches/com.electron.readmoo.ShipIt",
    "~/Library/HTTPStorages/com.electron.readmoo",
    "~/Library/Logs/Readmoo看書",
    "~/Library/Preferences/com.electron.readmoo.plist",
    "~/Library/Saved Application State/com.electron.readmoo.savedState",
  ]
end