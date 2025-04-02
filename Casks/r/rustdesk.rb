cask "rustdesk" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.3.9"
  sha256 arm:   "277414fdc648e007b4e15c7e0b48d69228e457bf6411e0ebb830ce5478dc7ec0",
         intel: "8b0061beaa2ebcaa90b53a33183527c803da1094e168177e6ed1d89cd56aae6d"

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