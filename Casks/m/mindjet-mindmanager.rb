cask "mindjet-mindmanager" do
  version "24.1.155"
  sha256 "984641a6620551efdf85066165ac6413d274c5b1a97378e08582c8c13a97fccb"

  url "https://download.mindjet.com/MindManager_Mac_#{version}.dmg"
  name "Mindmanager"
  desc "Mind Mapping Tool"
  homepage "https://www.mindjet.com/mindmanager/"

  livecheck do
    url "https://www.mindmanager.com/mm-mac-dmg"
    regex(/MindManager[._-]Mac[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :header_match
  end

  depends_on macos: ">= :ventura"

  app "MindManager.app"

  zap trash: [
    "~/Library/Application Support/Mindjet",
    "~/Library/Application Support/MindManager",
    "~/Library/Caches/com.mindjet.mindmanager.*",
    "~/Library/HTTPStorages/com.mindjet.mindmanager.*.binarycookies",
    "~/Library/Preferences/ByHost/com.mindjet.mindmanager.*.6B4DD3EE-2BFA-5A1C-A64F-50799C342D41.plist",
    "~/Library/Preferences/com.mindjet.mindmanager.*.plist",
    "~/Library/WebKit/com.mindjet.mindmanager.*",
  ]
end