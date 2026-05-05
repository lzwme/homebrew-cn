cask "macsyzones" do
  version "3.0"
  sha256 "c165ebafc7999248e133d006a6a568dc008237540d65e2e57af85ae417cabe87"

  url "https://ghfast.top/https://github.com/rohanrhu/MacsyZones/releases/download/v#{version}/MacsyZones.zip",
      verified: "github.com/rohanrhu/MacsyZones/"
  name "MacsyZones"
  desc "Window management utility"
  homepage "https://macsyzones.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "MacsyZones.app"

  zap trash: [
    "~/Library/Application Support/MacsyZones",
    "~/Library/Logs/MacsyZones",
    "~/Library/Preferences/com.macsyzones.MacsyZones.plist",
  ]
end