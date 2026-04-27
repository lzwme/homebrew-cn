cask "iptvnator" do
  arch arm: "arm64", intel: "x64"

  version "0.20.0"
  sha256 arm:   "f97f9402b2a794d24cd3755b085bb7faeb5402e5fbda9c050dc0cc4feaebd6f6",
         intel: "b1ed107cce69f5d13198dc7e7c5a802fc521b2b3a6a437eff7db855452f39f2c"

  url "https://ghfast.top/https://github.com/4gray/iptvnator/releases/download/v#{version}/iptvnator-#{version}-mac-#{arch}.dmg"
  name "IPTVnator"
  desc "Open Source m3u, m3u8 player"
  homepage "https://github.com/4gray/iptvnator"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  app "iptvnator.app"

  zap trash: [
    "~/Library/Application Support/iptvnator",
    "~/Library/Preferences/com.electron.iptvnator.plist",
    "~/Library/Saved Application State/com.electron.iptvnator.savedState",
  ]
end