cask "podman-desktop" do
  arch arm: "arm64", intel: "x64"

  version "1.16.1"
  sha256 arm:   "9062708f5b500829dfeaa4d9eb17c547526e72f6e2318d2ea6478afe04d7298e",
         intel: "cf179672ceffb798cd3d65febd0d6ef1893630c6c4a64a6dd19b75b1aab8e48e"

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
  depends_on macos: ">= :big_sur"

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