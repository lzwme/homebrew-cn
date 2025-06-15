cask "radiant-player" do
  version "1.12.0"
  sha256 "1a05de910d7fc0defcf010c7e0bbbb1eb32afc35a6eaa9397a5df57c6a5fc663"

  url "https:github.comradiant-playerradiant-player-macreleasesdownloadv#{version}radiant-player-v#{version}.zip",
      verified: "github.comradiant-playerradiant-player-mac"
  name "Radiant Player"
  desc "App wrapper for Google Play Music"
  homepage "https:radiant-player.github.ioradiant-player-mac"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Radiant Player.app"

  uninstall quit: "com.sajidanwar.Radiant-Player"

  zap trash: [
    "~LibraryApplication SupportRadiant Player",
    "~LibraryCachescom.sajidanwar.Radiant-Player",
    "~LibraryCookiescom.sajidanwar.Radiant-Player.binarycookies",
    "~LibraryPreferencescom.sajidanwar.Radiant-Player.plist",
    "~LibrarySaved Application Statecom.sajidanwar.Radiant-Player.savedState",
  ]
end