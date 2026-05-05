cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "3.3.17"
  sha256 arm:   "e04f94a993a6ecd8c7a6fc48567ae79793a0f7174cbaecb377082259e10d66b8",
         intel: "7789669a4e20627a6297fa0f6a4ec4a21c894631b1f646268e8a67d54c4f47a5"

  url "https://ghfast.top/https://github.com/streetwriters/notesnook/releases/download/v#{version}/notesnook_mac_#{arch}.dmg",
      verified: "github.com/streetwriters/notesnook/"
  name "Notesnook"
  desc "Privacy-focused note taking app"
  homepage "https://notesnook.com/"

  livecheck do
    url "https://notesnook.com/api/v1/releases/darwin/latest/latest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on :macos

  app "Notesnook.app"

  zap trash: [
    "~/Library/Application Support/Notesnook",
    "~/Library/Logs/Notesnook",
    "~/Library/Preferences/com.streetwriters.notesnook.plist",
  ]
end