cask "cabal" do
  version "8.0.0"
  sha256 "bb62f21d9dc51b31c9fcc4d5a7bc48898270cfd62059efb4265f413093d5050d"

  url "https:github.comcabal-clubcabal-desktopreleasesdownloadv#{version}cabal-desktop-#{version}-mac.dmg",
      verified: "github.comcabal-clubcabal-desktop"
  name "Cabal"
  desc "Desktop client for the chat platform Cabal"
  homepage "https:cabal.chat"

  app "Cabal.app"

  zap trash: [
    "~.cabal-desktop",
    "~LibraryApplication SupportCabal",
    "~LibraryPreferencesclub.cabal.desktop.plist",
    "~LibrarySaved Application Stateclub.cabal.desktop.savedState",
  ]
end