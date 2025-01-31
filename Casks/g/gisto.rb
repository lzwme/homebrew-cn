cask "gisto" do
  arch arm: "aarch64", intel: "x64"

  version "2.0.0-1"
  sha256 arm:   "e53304e5bc6ab8ef3a420bf4d02e5507cbb58d3e7993c221cd5a95f7c4ef9643",
         intel: "f281a9b63ddc1e7660a0c99333145616e377557d95ffb8bc64f29e7db3a6150e"

  url "https:github.comGistoGistoreleasesdownloadv#{version}Gisto_#{version}_#{arch}.dmg",
      verified: "github.comGistoGisto"
  name "Gisto"
  desc "Snippets management desktop application"
  homepage "https:www.gisto.org"

  app "Gisto.app"

  zap trash: [
    "~LibraryApplication SupportGisto",
    "~LibraryCachescom.gistoapp.gisto2",
    "~LibraryLogsGisto",
    "~LibraryPreferencescom.gistoapp.gisto2.helper.plist",
    "~LibraryPreferencescom.gistoapp.gisto2.plist",
    "~LibrarySaved Application Statecom.gistoapp.gisto2.savedState",
  ]
end