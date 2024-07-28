cask "markright" do
  version "0.1.11"
  sha256 "2d293121534a468e5f166e18eaa28f8db7e39a617b092e06c0d8b339191d9f47"

  url "https:github.comdvcrnmarkrightreleasesdownload#{version}MarkRight_Mac.dmg"
  name "MarkRight"
  desc "Electron-powered markdown editor with live preview"
  homepage "https:github.comdvcrnmarkright"

  deprecate! date: "2024-07-27", because: :unmaintained

  app "MarkRight.app"

  zap trash: [
    "~LibraryApplication SupportMarkRight",
    "~LibraryCachesMarkRight",
    "~LibraryPreferencescom.electron.markright.plist",
  ]

  caveats do
    requires_rosetta
  end
end