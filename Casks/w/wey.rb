cask "wey" do
  version "0.3.7"
  sha256 "5ebbfad23a598d64c2fa1c311877546ae9b9c4e41e4040395496231fc70f68ec"

  url "https:github.comyueweyreleasesdownloadv#{version}wey-v#{version}-darwin-x64.zip"
  name "Wey"
  desc "Open-source Slack desktop app"
  homepage "https:github.comyuewey"

  app "Wey.app"

  zap trash: [
    "~LibraryApplication SupportWey",
    "~LibraryCachesorg.yue.wey",
    "~LibraryPreferencesorg.yue.wey.plist",
    "~LibrarySaved Application Stateorg.yue.wey.savedState",
    "~LibraryWebKitorg.yue.wey",
  ]

  caveats do
    discontinued
  end
end