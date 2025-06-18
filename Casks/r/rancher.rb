cask "rancher" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.19.2"
  sha256 arm:   "854aec45593b5368d8d8cbef1e9a0cdab29a9398dfead30d3fce779022a3e7ec",
         intel: "f261c6ffa994366b0d2fb11bd6305123cff0740973c393d3bafdaa6d7fe5eb97"

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