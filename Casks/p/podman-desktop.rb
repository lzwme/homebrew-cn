cask "podman-desktop" do
  arch arm: "arm64", intel: "x64"

  version "1.11.1"
  sha256 arm:   "58412b09133813780c394a81e40db60b2682180201307e5c3a78b11d2389e8d7",
         intel: "6eb3d7e4471a81c1169e80de83107b78255c899cef6c4b6e7beee84c7ab13494"

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