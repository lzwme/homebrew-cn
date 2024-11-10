cask "balenaetcher" do
  arch arm: "arm64", intel: "x64"

  version "1.19.25"
  sha256 arm:   "efbe29036616540d3dd727560ad3376c03b7ad4a6f5d9db090cf18a8c2a3685e",
         intel: "c320bb72639444bfd886bdc01f17c7f0d46b0fb6c5d1e9d4e95facdbc261ec7d"

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