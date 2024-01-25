cask "rancher" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.12.2"
  sha256 arm:   "9ab8131239a34ff880b79617f71254a502fb30a3dd7908b13533b84e9698a499",
         intel: "299034631ee0faa747f55b2ca7d6682419a15563a706ef8a2415e8638108fd35"

  url "https:github.comrancher-sandboxrancher-desktopreleasesdownloadv#{version}Rancher.Desktop-#{version}.#{arch}.dmg",
      verified: "github.comrancher-sandboxrancher-desktop"
  name "Rancher Desktop"
  desc "Kubernetes and container management on the desktop"
  homepage "https:rancherdesktop.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  conflicts_with cask: "docker"

  app "Rancher Desktop.app"

  uninstall quit:   "io.rancherdesktop.app",
            delete: [
              "optrancher-desktop",
              "privateetcsudoers.dzzzzz-rancher-desktop-lima", # zzzzz is not a typo
              "privatevarrundocker.sock",
              "privatevarrunrancher-desktop-*",
            ]

  zap trash: [
    "~.kuberlr",
    "~.rd",
    "~LibraryApplication SupportCachesrancher-desktop-updater",
    "~LibraryApplication SupportRancher Desktop",
    "~LibraryApplication Supportrancher-desktop",
    "~LibraryCachesio.rancherdesktop.app*",
    "~LibraryCachesrancher-desktop",
    "~LibraryLogsrancher-desktop",
    "~LibraryPreferencesByHostio.rancherdesktop.app*",
    "~LibraryPreferencesio.rancherdesktop.app.plist",
    "~LibraryPreferencesrancher-desktop",
    "~LibrarySaved Application Stateio.rancherdesktop.app.savedState",
  ]
end