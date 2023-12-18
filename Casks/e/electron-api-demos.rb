cask "electron-api-demos" do
  version "2.0.2"
  sha256 "274e1f3c2a90ab884b117af84988c1aea9931d37fe8169fb6aeecab8e5b78464"

  url "https:github.comelectronelectron-api-demosreleasesdownloadv#{version}electron-api-demos-mac.zip"
  name "Electron API Demos"
  desc "Explore the Electron APIs"
  homepage "https:github.comelectronelectron-api-demos"

  app "Electron API Demos.app"

  zap trash: [
    "~LibraryApplication SupportElectron API Demos",
    "~LibraryCachescom.electron.electron-api-demos",
    "~LibraryCachescom.electron.electron-api-demos.ShipIt",
    "~LibraryPreferencescom.electron.electron-api-demos.helper.plist",
    "~LibraryPreferencescom.electron.electron-api-demos.plist",
    "~LibrarySaved Application Statecom.electron.electron-api-demos.savedState",
  ]

  caveats do
    discontinued
  end
end