cask "jamf-migrator" do
  version "7.4.0"
  sha256 "38df4c20158b23d8da6c37a4e0b5b65d0b09993dedd98009728b410134055a6a"

  url "https:github.comjamfJamfMigratorreleasesdownloadv#{version}jamf-migrator.zip"
  name "JamfMigrator"
  desc "Tool to migrate data granularly between Jamf Pro servers"
  homepage "https:github.comjamfJamfMigrator"

  depends_on macos: ">= :high_sierra"

  app "jamf-migrator.app"

  zap trash: [
    "~LibraryApplication Scriptscom.jamf.jamf-migrator",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.jamf.jamf-migrator.sfl*",
    "~LibraryContainerscom.jamf.jamf-migrator",
  ]
end