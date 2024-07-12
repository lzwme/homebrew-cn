cask "gisto" do
  version "1.13.4"
  sha256 "40b8cb8654231af8550d0df76d39a8e69eb1e2fc909faba68882f2fe3576800e"

  url "https:github.comGistoGistoreleasesdownloadv#{version}Gisto-#{version}.dmg",
      verified: "github.comGistoGisto"
  name "Gisto"
  desc "Snippets management desktop application with (team) sharing options"
  homepage "https:www.gistoapp.com"

  deprecate! date: "2024-07-11", because: :unmaintained

  app "Gisto.app"

  zap trash: [
    "~LibraryApplication SupportGisto",
    "~LibraryLogsGisto",
    "~LibraryPreferencescom.gistoapp.gisto2.plist",
    "~LibrarySaved Application Statecom.gistoapp.gisto2.savedState",
  ]

  caveats do
    requires_rosetta
  end
end