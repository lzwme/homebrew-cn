cask "eloquent" do
  version "2.6.7"
  sha256 "e7872c6ce9e925e053d62be88e0bfd96dd36359551165aa506ec0e9ede193c55"

  url "https:github.commdbergmannEloquentreleasesdownload#{version}Eloquent-#{version}.app.zip"
  name "Eloquent"
  desc "Freeopen-source Bible study application, based on the SWORD Project"
  homepage "https:github.commdbergmannEloquent"

  no_autobump! because: :requires_manual_review

  auto_updates true

  app "Eloquent.app"

  zap trash: [
    "~LibraryApplication SupportEloquent",
    "~LibraryLogsEloquent.log",
    "~LibraryPreferencesorg.crosswire.Eloquent.plist",
    "~LibraryPreferencesorg.crosswire.Eloquent.plist.lockfile",
    "~LibrarySaved Application Stateorg.crosswire.Eloquent.savedState",
  ]
end