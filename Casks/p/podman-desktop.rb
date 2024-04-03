cask "podman-desktop" do
  arch arm: "arm64", intel: "x64"

  version "1.8.0"
  sha256 arm:   "ca69d66d4fef59c35abd47fcfbd80787f256cfd986969e4139f6e8b32bb95b6a",
         intel: "ce5baca20b906d329bbc58fa9114e7605311cf31c5d03cc21283b445891c6e81"

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