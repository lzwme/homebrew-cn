cask "balenaetcher" do
  version "1.18.11"
  sha256 "251f403b79f53bbf7c558cb0b6ce085bd9d4f1fb7f70d96fdfc10ecbc493e70f"

  url "https:github.combalena-ioetcherreleasesdownloadv#{version}balenaEtcher-#{version}.dmg",
      verified: "github.combalena-ioetcher"
  name "Etcher"
  desc "Tool to flash OS images to SD cards & USB drives"
  homepage "https:balena.ioetcher"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "balenaEtcher.app"

  uninstall quit: "io.balena.etcher.*"

  zap trash: [
    "~LibraryApplication Supportbalena-etcher",
    "~LibraryPreferencesio.balena.etcher.helper.plist",
    "~LibraryPreferencesio.balena.etcher.plist",
    "~LibrarySaved Application Stateio.balena.etcher.savedState",
  ]
end