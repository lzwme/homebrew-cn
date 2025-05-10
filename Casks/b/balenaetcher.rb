cask "balenaetcher" do
  arch arm: "arm64", intel: "x64"

  version "2.1.2"
  sha256 arm:   "b2a5db16d98253e1fd7467a4cd467003c526a29e2d498282c74766f051c19606",
         intel: "51e793283ab18ce06f8dd0c2a263b405b578c3ff9fe3db33f5ec64d33eae3b61"

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
    "~LibraryApplication SupportbalenaEtcher",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsio.balena.etcher.sfl*",
    "~LibraryPreferencesio.balena.etcher.helper.plist",
    "~LibraryPreferencesio.balena.etcher.plist",
    "~LibrarySaved Application Stateio.balena.etcher.savedState",
  ]
end