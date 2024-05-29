cask "podman-desktop" do
  arch arm: "arm64", intel: "x64"

  version "1.10.3"
  sha256 arm:   "fa81a02b805df8145fec0f2f9a68d8c4a46df6c1a5684555785b34aa4fe95054",
         intel: "a662de4aba0ca75c82dc9551bb9c2afc5d4384c075ee0cd7e7759aaf6e8a4d13"

  url "https:github.comcontainerspodman-desktopreleasesdownloadv#{version}podman-desktop-#{version}-#{arch}.dmg",
      verified: "github.comcontainerspodman-desktop"
  name "Podman Desktop"
  desc "Browse, manage, inspect containers and images"
  homepage "https:podman-desktop.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Podman Desktop.app"

  uninstall quit:   "io.podmandesktop.PodmanDesktop",
            delete: "ApplicationsPodman Desktop.app",
            trash:  "~LibraryLaunchAgentsio.podman_desktop.PodmanDesktop.plist"

  zap trash: [
    "~.localsharecontainerspodman-desktop",
    "~LibraryApplication SupportPodman Desktop",
    "~LibraryPreferencesio.podmandesktop.PodmanDesktop.plist",
    "~LibrarySaved Application Stateio.podmandesktop.PodmanDesktop.savedState",
  ]
end