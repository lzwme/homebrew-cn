cask "gisto" do
  arch arm: "aarch64", intel: "x64"

  version "2.1.4"
  sha256 arm:   "530afe82c1d999d8611c4e0bf983303775ba7b5e337b4d41014783491186f097",
         intel: "8e55c0ad9663364869b7be4905e17adb221828fe932f84a79543f655c9c9ba0c"

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