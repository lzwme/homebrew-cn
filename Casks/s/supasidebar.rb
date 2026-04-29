cask "supasidebar" do
  version "0.17.1"
  sha256 "6b4c8b231deaae61052531c139e0e8b0b03f224cc41f7d1334eb75e8ea069b35"

  url "https://ghfast.top/https://github.com/auspy/supasidebar-updates/releases/download/v#{version}/supasidebar_v#{version}.dmg",
      verified: "github.com/auspy/supasidebar-updates/"
  name "SupaSidebar"
  desc "Arc-like sidebar to save links, files and folders from any browser"
  homepage "https://supasidebar.com/"

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "supasidebar.app"

  uninstall quit: "com.supasidebar"

  zap trash: [
    "~/Library/Application Support/com.supasidebar",
    "~/Library/Caches/com.supasidebar",
    "~/Library/HTTPStorages/com.supasidebar",
    "~/Library/HTTPStorages/com.supasidebar.binarycookies",
    "~/Library/Preferences/com.supasidebar.plist",
    "~/Library/Saved Application State/com.supasidebar.savedState",
  ]
end