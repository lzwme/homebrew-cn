cask "rustdesk" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.2.3"
  sha256 arm:   "647bc014238086d7a73a3d8f1543a1a559b5240f1796e1311a2142be0b57152e",
         intel: "63f1f5bbe2a308495be039604886adc83937bc36e97b09d4fd9b675ee108ee09"

  url "https:github.comrustdeskrustdeskreleasesdownload#{version}rustdesk-#{version}-#{arch}.dmg",
      verified: "github.comrustdeskrustdesk"
  name "RustDesk"
  desc "Open source virtualremote desktop application"
  homepage "https:rustdesk.com"

  livecheck do
    url :url
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