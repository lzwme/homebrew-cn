cask "balenaetcher" do
  arch arm: "arm64", intel: "x64"

  version "2.1.0"
  sha256 arm:   "7b6ef50c0f20a421e58766b77d6c4ccb4af4912c15f4cd9a029e7e5aa439677f",
         intel: "1038a0db3cf928fde60bd60f84564e263a5aba8ae7df42cf251940d285f51a7e"

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