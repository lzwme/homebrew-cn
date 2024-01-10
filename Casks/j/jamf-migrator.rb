cask "jamf-migrator" do
  version "7.4.1"
  sha256 "8743da3d1942379b1580d50e7b8861efbece1c65c000764194fbae8627c235be"

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