cask "electrocrud" do
  version "3.0.19"
  sha256 "d605885ae136077e001ae48c008147008501fd305bdf3de296a4553eb7195e4a"

  url "https:github.comgarrylachmanElectroCRUDreleasesdownloadv#{version}ElectroCRUD-v#{version}-mac-x64.dmg"
  name "ElectroCRUD"
  desc "Database CRUD application"
  homepage "https:github.comgarrylachmanElectroCRUD"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "electrocrud.app"

  zap trash: [
    "~LibraryApplication SupportElectroCRUD",
    "~LibraryPreferencescom.garrylachman.electrocrud.plist",
    "~LibrarySaved Application Statecom.garrylachman.electrocrud.savedState",
  ]
end