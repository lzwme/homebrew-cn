cask "rancher" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.15.0"
  sha256 arm:   "554b752d409f653901ece098812d91af755ab92e54dfe4e0383f483637940741",
         intel: "216633bad2701f9ea46b64e00f4168ed4e33a23d2a7287253c0ddf94cfcd46f1"

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