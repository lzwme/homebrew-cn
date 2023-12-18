cask "postbird" do
  version "0.8.4"
  sha256 "d9ac960e0c48fab31b0662c726a3eb373794c14dd49651fa533ca3c1c67c67be"

  url "https:github.comPaxapostbirdreleasesdownload#{version}Postbird-#{version}.dmg"
  name "Postbird"
  desc "Open-source PostgreSQL GUI client"
  homepage "https:github.comPaxapostbird"

  app "Postbird.app"

  zap trash: [
    "~LibraryApplication SupportPostbird",
    "~LibraryPreferencescom.electron.postbird.plist",
    "~LibrarySaved Application Statecom.electron.postbird.savedState",
  ]
end