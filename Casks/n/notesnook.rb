cask "notesnook" do
  arch arm: "arm64", intel: "x64"

  version "3.3.16"
  sha256 arm:   "6b84bff54ff073d5c6896875612ec07843f76c01b008b72019627ea8bedc4c90",
         intel: "1d772b94ec07a980125686eda044b5f80d635ef1813c8fe13cda773128d24638"

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