cask "rancher" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.18.2"
  sha256 arm:   "b2ceca9e71f2b01ab8db661456a3b68e77f561077ea6b194fe0535ef20e6eafd",
         intel: "01d135478cd8f3f4d955f5ac305d299399b51666c7fd24fa2841cc1e83f3d339"

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
  depends_on macos: ">= :catalina"

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