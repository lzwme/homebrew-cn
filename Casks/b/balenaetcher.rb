cask "balenaetcher" do
  arch arm: "arm64", intel: "x64"

  version "1.19.21"
  sha256 arm:   "fa7aa1f41f2bb3aebf9e9a61b526dc3297f85f3cbd9eff8f5cb3c4d1e5200c9b",
         intel: "028123c9b839574025d918ede39b9c62a1fa7a4fbb859e31fc538ab811a2db6f"

  url "https:github.combalena-ioetcherreleasesdownloadv#{version}balenaEtcher-#{version}-#{arch}.dmg",
      verified: "github.combalena-ioetcher"
  name "Etcher"
  desc "Tool to flash OS images to SD cards & USB drives"
  homepage "https:balena.ioetcher"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "balenaEtcher.app"

  uninstall quit: "io.balena.etcher.*"

  zap trash: [
    "~LibraryApplication Supportbalena-etcher",
    "~LibraryPreferencesio.balena.etcher.helper.plist",
    "~LibraryPreferencesio.balena.etcher.plist",
    "~LibrarySaved Application Stateio.balena.etcher.savedState",
  ]
end