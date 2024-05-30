cask "balenaetcher" do
  arch arm: "arm64", intel: "x64"

  version "1.19.19"
  sha256 arm:   "918178cedc5ddb40743ce876cb94c712fc49140f861025b2bb9b0661f43057a6",
         intel: "2cc29d9bded48cb846fe596597f3064639922a7cff42855ca0210cc67ecf9a6c"

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