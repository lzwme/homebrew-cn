cask "rustdesk" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.3.5"
  sha256 arm:   "f930a89535b88fe756a9fd53df31d7fd466887af5c2f763e9284fc86c4fd5eaf",
         intel: "06c1d3de21c8a87c5a8773dbd7fdaaa34cae1829792865b13dd6f587eef2e15f"

  url "https:github.comrustdeskrustdeskreleasesdownload#{version}rustdesk-#{version}-#{arch}.dmg",
      verified: "github.comrustdeskrustdesk"
  name "RustDesk"
  desc "Open source virtualremote desktop application"
  homepage "https:rustdesk.com"

  livecheck do
    url :url
    regex(^v?(\d+(?:[.-]\d+)+)$i)
    strategy :github_latest
  end

  depends_on macos: ">= :mojave"

  app "RustDesk.app"

  uninstall quit: "com.carriez.rustdesk"

  zap trash: [
    "LibraryLaunchAgentscom.carriez.RustDesk_server.plist",
    "LibraryLaunchDaemonscom.carriez.RustDesk_service.plist",
    "~LibraryLogsRustDesk",
    "~LibraryPreferencescom.carriez.RustDesk",
    "~LibrarySaved Application Statecom.carriez.rustdesk.savedState",
  ]
end