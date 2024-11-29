cask "rustdesk" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.3.3"
  sha256 arm:   "24c1112597203c22af9e7f67744625d432e6e80ea1ffda84daeb0f1f73941d32",
         intel: "97fa459500748dd5fa70fa8782b65e30ba53c9b5e09b8a63582f3cbb5e1e6abd"

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