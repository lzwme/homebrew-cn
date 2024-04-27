cask "dockmate" do
  version "0.8.7"
  sha256 "0bff2c4b3c915bbd8719a57fd8f2b6c7251af01ceb625bd554fc0326e3fcaf35"

  url "https:raw.githubusercontent.comw0lfschildapp_updatesmasterDockMateDockMate.#{version}.zip",
      verified: "raw.githubusercontent.comw0lfschild"
  name "Dock Mate"
  desc "Window previews and controls"
  homepage "https:www.macenhance.comdockmate"

  livecheck do
    url "https:raw.githubusercontent.comw0lfschildapp_updatesmasterDockMateappcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :mojave"

  app "DockMate.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.macenhance.dockmate.sfl*",
    "~LibraryApplication Supportcom.macenhance.dockmate",
    "~LibraryApplication SupportDockMate",
    "~LibraryCachescom.macenhance.dockmate",
    "~LibraryCachescom.plausiblelabs.crashreporter.datacom.macenhance.dockmate",
    "~LibraryHTTPStoragescom.macenhance.dockmate",
    "~LibraryHTTPStoragescom.macenhance.dockmate.binarycookies",
    "~LibraryPreferencescom.macenhance.dockmate.plist",
  ]
end