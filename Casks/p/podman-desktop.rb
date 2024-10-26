cask "podman-desktop" do
  arch arm: "arm64", intel: "x64"

  version "1.13.3"
  sha256 arm:   "2e3eb23659d63ae53b6f5cb88184b88df7fb4622af5dd07af884e447230653a7",
         intel: "1c1ef357ebaa2ac4901f44d95473fdfaede8b4c9ec765affdf2995a1a6347d7f"

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