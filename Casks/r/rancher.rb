cask "rancher" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.14.0"
  sha256 arm:   "4ba7189220156b5b4188165148b05f6432ecd87df3f7f32816517b7c9e2015fc",
         intel: "7d80b2bb4540ddc9f94a6d8191db7183eb44db8ba55f10ce25b4839508eb4472"

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