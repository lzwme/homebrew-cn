cask "upterm" do
  version "0.4.4"
  sha256 "5394926add794e486172c72ef0dc04c225a481d2970f968522c0436ef42677ee"

  url "https:github.comrailswareuptermreleasesdownloadv#{version}upterm-#{version}-macOS.dmg"
  name "Upterm"
  desc "Terminal emulator for the 21st century"
  homepage "https:github.comrailswareupterm"

  disable! date: "2024-12-16", because: :discontinued

  app "Upterm.app"

  zap trash: [
    "~.upterm",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.github.railsware.upterm.sfl*",
    "~LibraryApplication SupportUpterm",
    "~LibraryPreferencescom.github.railsware.upterm.helper.plist",
    "~LibraryPreferencescom.github.railsware.upterm.plist",
    "~LibrarySaved Application Statecom.github.railsware.upterm.savedState",
  ]
end