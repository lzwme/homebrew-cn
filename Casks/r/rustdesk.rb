cask "rustdesk" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.3.7"
  sha256 arm:   "e5cc9b86d1f687e9a447d6c2d373584349ce1bf841d70887909e0e0e388fcbe2",
         intel: "9e97eab552982948b6b2e7462eeb104b00e5ad0e7ae381258129b28f663d6ab6"

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