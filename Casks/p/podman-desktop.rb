cask "podman-desktop" do
  arch arm: "arm64", intel: "x64"

  version "1.6.4"
  sha256 arm:   "e38c14e1c14ee08c4c634ff2ab373cc0f16149904fec3059cfa854ed1a43d0ea",
         intel: "c1ffc84130eefd83e5410b2360896e26def5931abdc1d32b93c69d3b7f1de2f1"

  url "https:github.comcontainerspodman-desktopreleasesdownloadv#{version}podman-desktop-#{version}-#{arch}.dmg",
      verified: "github.comcontainerspodman-desktop"
  name "Podman Desktop"
  desc "Browse, manage, inspect containers and images"
  homepage "https:podman-desktop.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on formula: "podman"
  depends_on macos: ">= :catalina"

  app "Podman Desktop.app"

  uninstall quit:  "io.podmandesktop.PodmanDesktop",
            trash: "~LibraryLaunchAgentsio.podman_desktop.PodmanDesktop.plist"

  zap trash: [
    "~.localsharecontainerspodman-desktop",
    "~LibraryApplication SupportPodman Desktop",
    "~LibraryPreferencesio.podmandesktop.PodmanDesktop.plist",
    "~LibrarySaved Application Stateio.podmandesktop.PodmanDesktop.savedState",
  ]
end