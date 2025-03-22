cask "podman-desktop" do
  arch arm: "arm64", intel: "x64"

  version "1.17.2"
  sha256 arm:   "1cf658a9da347cead875ceddd9200388075a4834bc3b8e2d9aa47ad2b05c547f",
         intel: "02de5f7bce5c9d09fcd9965a2944e6c59515f8f40dea05be97ad32a28a0739c2"

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