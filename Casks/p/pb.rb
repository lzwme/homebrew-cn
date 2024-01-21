cask "pb" do
  version "11.0.2"
  sha256 "fdf0f2e7b820e5efbc9b0c7e69dfdcb4ac3caa3012ed7086d59a62c190f7c3e2"

  url "https:github.comsidneyspb-for-desktopreleasesdownloadv#{version}pb-for-desktop-#{version}-mac.zip",
      verified: "github.comsidneyspb-for-desktop"
  name "PB for Desktop"
  desc "Unofficial Pushbullet desktop app to get push notifications"
  homepage "https:sidneys.github.iopb-for-desktop"

  auto_updates true

  app "PB for Desktop.app"

  uninstall launchctl: "PB for Desktop",
            quit:      [
              "de.sidneys.pb-for-desktop",
              "de.sidneys.pb-for-desktop.helper",
              "de.sidneys.pb-for-desktop.helper.GPU",
              "de.sidneys.pb-for-desktop.helper.Plugin",
              "de.sidneys.pb-for-desktop.helper.Renderer",
            ]

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsde.sidneys.pb-for-desktop.sfl*",
    "~LibraryApplication Supportde.sidneys.pb-for-desktop.ShipIt",
    "~LibraryApplication SupportPB for Desktop",
    "~LibraryApplication SupportShipIt_stderr.log",
    "~LibraryApplication SupportShipIt_stdout.log",
    "~LibraryCachesde.sidneys.pb-for-desktop",
    "~LibraryCachesde.sidneys.pb-for-desktop.ShipIt",
    "~LibraryLogsPB for Desktop",
    "~LibraryPreferencesByHostde.sidneys.pb-for-desktop.ShipIt.*.plist",
    "~LibraryPreferencesde.sidneys.pb-for-desktop.helper.plist",
    "~LibraryPreferencesde.sidneys.pb-for-desktop.plist",
    "~LibrarySaved Application Statede.sidneys.pb-for-desktop.savedState",
    "~LibraryWebKitde.sidneys.pb-for-desktop",
  ]
end